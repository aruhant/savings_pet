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
    """Represents a single change event from the stream, deserialized to LogEntry."""
    
    def __init__(self, event_type: StreamEventType, new_item: Optional['LogEntry'] = None, old_item: Optional['LogEntry'] = None):
        self.type = event_type
        self.new_item = new_item
        self.old_item = old_item


class LogEntry:
    """Python equivalent of the Dart LogEntry class."""
    
    def __init__(self, text: Optional[str] = None, sender: Optional[str] = None, 
                 category: Optional[str] = None, time: Optional[str] = None,
                 recipient: Optional[str] = None, entry_type: Optional[str] = None,
                 merchant: Optional[str] = None, amount: Optional[float] = None,
                 key: Optional[str] = None, user_id: Optional[str] = None):
        self.text = text
        self.sender = sender
        self.category = category
        self.time = time
        self.recipient = recipient or "demo_user"
        self.type = entry_type
        self.merchant = merchant
        self.amount = amount
        self.key = key or str(int(datetime.now().timestamp() * 1000))
        self.user_id = user_id
    
    @classmethod
    def from_dynamo_item(cls, item: Dict[str, Any]) -> 'LogEntry':
        """Convert DynamoDB item to LogEntry object."""
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
            else:
                return None
        
        return cls(
            text=get_value(item, 'text'),
            sender=get_value(item, 'sender'),
            category=get_value(item, 'category'),
            time=get_value(item, 'time'),
            recipient=get_value(item, 'recepient'),  # Note: keeping typo from Dart code
            entry_type=get_value(item, 'type'),
            merchant=get_value(item, 'merchant'),
            amount=get_value(item, 'amount'),
            key=get_value(item, 'key'),
            user_id=get_value(item, 'userID')
        )
    
    @classmethod
    def from_json(cls, json_data: Dict[str, Any]) -> 'LogEntry':
        """Convert JSON dict to LogEntry object."""
        return cls(
            text=json_data.get('text'),
            sender=json_data.get('sender'),
            category=json_data.get('category'),
            time=json_data.get('time'),
            recipient=json_data.get('recepient'),  # Note: keeping typo from Dart code
            entry_type=json_data.get('type'),
            merchant=json_data.get('merchant'),
            amount=float(json_data['amount']) if json_data.get('amount') is not None else None,
            key=json_data.get('key'),
            user_id=json_data.get('userID')
        )
    
    def __str__(self) -> str:
        return f"LogEntry(text='{self.text}', sender='{self.sender}', category='{self.category}', " \
               f"time='{self.time}', key='{self.key}', recipient='{self.recipient}', " \
               f"type='{self.type}', amount={self.amount}, merchant='{self.merchant}')"


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
    
    def get_current_items(self, user_id: str = "demo_user") -> List[LogEntry]:
        """Get all current items from the table for the specified user."""
        try:
            response = self.dynamodb.scan(
                TableName=self.table_name,
                FilterExpression='userID = :uid',
                ExpressionAttributeValues={
                    ':uid': {'S': user_id}
                }
            )
            
            items = []
            if 'Items' in response:
                for item in response['Items']:
                    try:
                        log_entry = LogEntry.from_dynamo_item(item)
                        items.append(log_entry)
                    except Exception as e:
                        print(f"Error converting item: {e}")
                        continue
            
            return items
        except Exception as e:
            print(f"Error scanning table: {e}")
            return []
    
    def listen(self, on_events: Callable[[List[StreamEvent]], None], user_id: str = "demo_user"):
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
                    self._poll_shard(stream_arn, shard_id, on_events, user_id)
                    
        except Exception as e:
            print(f"An error occurred while initializing the stream listener: {e}")
    
    def _poll_shard(self, stream_arn: str, shard_id: str, 
                   on_events: Callable[[List[StreamEvent]], None], user_id: str):
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
                        events = self._process_records(records, user_id)
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
    
    def _process_records(self, records: List[Dict[str, Any]], user_id: str) -> List[StreamEvent]:
        """Process records from the stream and return relevant events."""
        events = []
        
        for record in records:
            try:
                # Check if this record belongs to the current user
                dynamodb_record = record.get('dynamodb', {})
                new_image = dynamodb_record.get('NewImage')
                old_image = dynamodb_record.get('OldImage')
                
                # Filter by user ID
                record_user_id = None
                if new_image and 'userID' in new_image:
                    record_user_id = new_image['userID'].get('S')
                elif old_image and 'userID' in old_image:
                    record_user_id = old_image['userID'].get('S')
                
                if record_user_id != user_id:
                    continue
                
                # Map event type
                event_name = record.get('eventName', '').lower()
                event_type = self._map_event_type(event_name)
                if not event_type:
                    continue
                
                # Convert images to LogEntry objects
                new_item = None
                old_item = None
                
                if new_image:
                    new_item = LogEntry.from_dynamo_item(new_image)
                
                if old_image:
                    old_item = LogEntry.from_dynamo_item(old_image)
                
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


def listen_for_transactions(table_name: str = "messages", user_id: str = "demo_user"):
    """
    Main function that listens for new transactions and prints messages when detected.
    
    Args:
        table_name: Name of the DynamoDB table to monitor
        user_id: User ID to filter transactions for
    """
    print(f"Starting transaction listener for table '{table_name}' and user '{user_id}'...")
    
    # Create stream listener
    listener = DynamoStreamListener(table_name)
    
    def handle_events(events: List[StreamEvent]):
        """Handle stream events and print transaction messages."""
        for event in events:
            if event.type == StreamEventType.INSERT and event.new_item:
                log_entry = event.new_item
                
                # Check if this is a transaction (has amount and type)
                if log_entry.amount is not None and log_entry.type:
                    transaction_type = "💰 Income" if log_entry.type == "income" else "💸 Expense"
                    amount_str = f"${log_entry.amount:.2f}" if log_entry.amount else "Unknown amount"
                    merchant = log_entry.merchant or "Unknown merchant"
                    category = log_entry.category or "Other"
                    
                    print(f"\n🚨 NEW TRANSACTION DETECTED!")
                    print(f"   Type: {transaction_type}")
                    print(f"   Amount: {amount_str}")
                    print(f"   Merchant: {merchant}")
                    print(f"   Category: {category}")
                    print(f"   Time: {log_entry.time}")
                    print(f"   Key: {log_entry.key}")
                    if log_entry.text:
                        print(f"   Message: {log_entry.text}")
                    print("-" * 50)
                else:
                    print(f"\n📝 New log entry: {log_entry}")
            
            elif event.type == StreamEventType.MODIFY:
                print(f"\n✏️ Transaction modified: {event.new_item}")
            
            elif event.type == StreamEventType.REMOVE:
                print(f"\n🗑️ Transaction removed: {event.old_item}")
    
    try:
        # Start listening to the stream
        listener.listen(handle_events, user_id)
    except KeyboardInterrupt:
        print("\n\nStopping transaction listener...")
    except Exception as e:
        print(f"Error in transaction listener: {e}")


if __name__ == "__main__":
    # Example usage
    listen_for_transactions()

