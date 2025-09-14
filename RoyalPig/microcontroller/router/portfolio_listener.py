import boto3
import time
import json
from enum import Enum
from typing import Optional, List, Dict, Any, Callable
from datetime import datetime


class StreamEventType(Enum):
    """The type of change detected in the DynamoDB stream."""
    INSERT = "insert"
    MODIFY = "modify"
    REMOVE = "remove"


class StreamEvent:
    """Represents a single change event from the stream, deserialized to Portfolio."""
    
    def __init__(self, event_type: StreamEventType, new_item: Optional['Portfolio'] = None, old_item: Optional['Portfolio'] = None):
        self.type = event_type
        self.new_item = new_item
        self.old_item = old_item


class Portfolio:
    """Python equivalent of the Portfolio class."""
    
    def __init__(self, portfolio_id: Optional[str] = None, 
                 trailing_returns: Optional[Dict[str, str]] = None, 
                 calendar_returns: Optional[Dict[str, str]] = None):
        self.portfolio_id = portfolio_id
        self.trailing_returns = trailing_returns or {}
        self.calendar_returns = calendar_returns or {}
    
    @classmethod
    def from_dynamo_item(cls, item: Dict[str, Any]) -> 'Portfolio':
        """Convert DynamoDB item to Portfolio object."""
        def get_value(item_dict: Dict[str, Any], key: str) -> Any:
            """Extract value from DynamoDB attribute format."""
            if key not in item_dict:
                return None
            
            attr_value = item_dict[key]
            if 'S' in attr_value:  # String
                return attr_value['S']
            elif 'N' in attr_value:  # Number
                try:
                    return float(attr_value['N'])
                except ValueError:
                    return attr_value['N']
            elif 'B' in attr_value:  # Binary
                return attr_value['B']
            elif 'NULL' in attr_value and attr_value['NULL']:
                return None
            elif 'BOOL' in attr_value:
                return attr_value['BOOL']
            elif 'M' in attr_value:  # Map
                return {k: get_value({'M': v}, k) for k, v in attr_value['M'].items()}
            else:
                return None
        
        return cls(
            portfolio_id=get_value(item, 'portfolioId'),
            trailing_returns=get_value(item, 'trailingReturns'),
            calendar_returns=get_value(item, 'calendarReturns')
        )
    
    @classmethod
    def from_json(cls, json_data: Dict[str, Any]) -> 'Portfolio':
        """Convert JSON dict to Portfolio object."""
        return cls(
            portfolio_id=json_data.get('portfolioId'),
            trailing_returns=json_data.get('trailingReturns', {}),
            calendar_returns=json_data.get('calendarReturns', {})
        )
    
    def __str__(self) -> str:
        return f"Portfolio(portfolio_id='{self.portfolio_id}', trailing_returns={self.trailing_returns}, calendar_returns={self.calendar_returns})"


class DynamoStreamListener:
    """A generic listener for DynamoDB table streams."""
    
    def __init__(self, table_name: str, region: str = 'us-east-2', 
                 access_key: str = None, secret_key: str = None):
        self.table_name = table_name
        self.region = region
        
        # AWS credentials - in production, use IAM roles or environment variables
        self.access_key = access_key or ""
        self.secret_key = secret_key or ""
        
        # Initialize AWS clients
        self.dynamodb = boto3.client(
            'dynamodb',
            region_name=self.region,
            aws_access_key_id=self.access_key,
            aws_secret_access_key=self.secret_key
        )
        
        self.dynamodb_streams = boto3.client(
            'dynamodbstreams',
            region_name=self.region,
            aws_access_key_id=self.access_key,
            aws_secret_access_key=self.secret_key
        )
    
    def get_current_items(self) -> List[Portfolio]:
        """Get all current items from the table."""
        try:
            response = self.dynamodb.scan(TableName=self.table_name)
            
            items = []
            if 'Items' in response:
                for item in response['Items']:
                    try:
                        portfolio = Portfolio.from_dynamo_item(item)
                        items.append(portfolio)
                    except Exception as e:
                        print(f"Error converting item: {e}")
                        continue
            
            return items
        except Exception as e:
            print(f"Error scanning table: {e}")
            return []
    
    def listen(self, on_events: Callable[[List[StreamEvent]], None]):
        """Start listening to the stream and invoke the callback with new events."""
        print(f"Attempting to listen to stream for table: {self.table_name}")
        
        try:
            # Get table description to find stream ARN
            response = self.dynamodb.describe_table(TableName=self.table_name)
            table = response.get('Table', {})
            stream_arn = table.get('LatestStreamArn')
            
            if not stream_arn:
                print(f"Error: Stream not enabled for table '{self.table_name}' or table does not exist.")
                return
            
            print(f"Successfully found stream: {stream_arn}")
            
            # Get stream description
            stream_response = self.dynamodb_streams.describe_stream(StreamArn=stream_arn)
            stream_description = stream_response.get('StreamDescription', {})
            shards = stream_description.get('Shards', [])
            
            if not shards:
                print("No shards found for the stream.")
                return
            
            print(f"Found {len(shards)} shard(s). Starting listeners for each.")
            
            # For simplicity, we'll poll the first shard
            # In production, you'd want to handle multiple shards
            for shard in shards:
                shard_id = shard.get('ShardId')
                if shard_id:
                    self._poll_shard(stream_arn, shard_id, on_events)
                    
        except Exception as e:
            print(f"An error occurred while initializing the stream listener: {e}")
    
    def _poll_shard(self, stream_arn: str, shard_id: str, 
                   on_events: Callable[[List[StreamEvent]], None]):
        """Poll a single shard for records indefinitely."""
        try:
            # Get shard iterator
            iterator_response = self.dynamodb_streams.get_shard_iterator(
                StreamArn=stream_arn,
                ShardId=shard_id,
                ShardIteratorType='LATEST'
            )
            
            next_shard_iterator = iterator_response.get('ShardIterator')
            print(f"Starting to poll for changes on shard '{shard_id}'...")
            
            while next_shard_iterator:
                try:
                    # Get records from the stream
                    records_response = self.dynamodb_streams.get_records(
                        ShardIterator=next_shard_iterator
                    )
                    
                    records = records_response.get('Records', [])
                    if records:
                        events = self._process_records(records)
                        if events:
                            print(f"Detected {len(events)} new event(s) on shard '{shard_id}'.")
                            on_events(events)
                    
                    next_shard_iterator = records_response.get('NextShardIterator')
                    
                    if not next_shard_iterator:
                        print(f"Shard '{shard_id}' has been closed. Stopping polling for this shard.")
                        return
                        
                except Exception as e:
                    print(f"Error polling shard '{shard_id}': {e}. Retrying in 10 seconds...")
                    time.sleep(10)
                    continue
                
                # Wait before next poll
                time.sleep(5)
                
        except Exception as e:
            print(f"An error occurred while setting up polling for shard '{shard_id}': {e}")
    
    def _process_records(self, records: List[Dict[str, Any]]) -> List[StreamEvent]:
        """Process records from the stream and return relevant events."""
        events = []
        
        for record in records:
            try:
                # Map event type
                event_name = record.get('eventName', '').lower()
                event_type = self._map_event_type(event_name)
                if not event_type:
                    continue
                
                # Convert images to Portfolio objects
                dynamodb_record = record.get('dynamodb', {})
                new_image = dynamodb_record.get('NewImage')
                old_image = dynamodb_record.get('OldImage')
                
                new_item = None
                old_item = None
                
                if new_image:
                    new_item = Portfolio.from_dynamo_item(new_image)
                
                if old_image:
                    old_item = Portfolio.from_dynamo_item(old_image)
                
                events.append(StreamEvent(event_type, new_item, old_item))
                
            except Exception as e:
                print(f"Error processing record: {e}")
                continue
        
        return events
    
    def _map_event_type(self, event_name: str) -> Optional[StreamEventType]:
        """Map DynamoDB event name to StreamEventType."""
        event_mapping = {
            'insert': StreamEventType.INSERT,
            'modify': StreamEventType.MODIFY,
            'remove': StreamEventType.REMOVE
        }
        
        mapped_type = event_mapping.get(event_name)
        if not mapped_type:
            print(f"Unknown event type: {event_name}")
        
        return mapped_type


def analyze_portfolio(portfolio: Portfolio):
    """Placeholder analysis function for a newly inserted portfolio."""
    print(f"\n📊 Analyzing Portfolio: {portfolio.portfolio_id}")
    print(f"   Trailing Returns: {portfolio.trailing_returns}")
    print(f"   Calendar Returns: {portfolio.calendar_returns}")
    # Placeholder: Add actual analysis logic here, e.g., calculations or alerts
    print("   Analysis: This is a placeholder. Implement your analysis here.")
    print("-" * 50)


def listen_for_portfolios(table_name: str = "portfolios"):
    """
    Main function that listens for new portfolios and runs analysis on newly inserted items.
    
    Args:
        table_name: Name of the DynamoDB table to monitor
    """
    print(f"Starting portfolio listener for table '{table_name}'...")
    
    # Create stream listener
    listener = DynamoStreamListener(table_name)
    
    def handle_events(events: List[StreamEvent]):
        """Handle stream events and run analysis on new portfolios."""
        for event in events:
            if event.type == StreamEventType.INSERT and event.new_item:
                portfolio = event.new_item
                analyze_portfolio(portfolio)
            
            elif event.type == StreamEventType.MODIFY:
                print(f"\n✏️ Portfolio modified: {event.new_item}")
            
            elif event.type == StreamEventType.REMOVE:
                print(f"\n🗑️ Portfolio removed: {event.old_item}")
    
    try:
        # Start listening to the stream
        listener.listen(handle_events)
    except KeyboardInterrupt:
        print("\n\nStopping portfolio listener...")
    except Exception as e:
        print(f"Error in portfolio listener: {e}")


if __name__ == "__main__":
    # Example usage
    listen_for_portfolios()

