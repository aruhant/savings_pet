import boto3
import time
from datetime import datetime


def get_value(item_dict, key):
    """Extract value from DynamoDB attribute format."""
    if key not in item_dict:
        return None
    
    attr_value = item_dict[key]
    if 'S' in attr_value:  # String
        return attr_value['S']
    elif 'N' in attr_value:  # Number
        return attr_value['N']
    elif 'BOOL' in attr_value:
        return attr_value['BOOL']
    else:
        return None


def query_existing_messages(dynamodb_client, table_name):
    """Query all existing messages from the table."""
    try:
        print(f"📋 Querying existing messages...")
        
        response = dynamodb_client.scan(TableName=table_name)
        
        items = response.get('Items', [])
        print(f"📊 Found {len(items)} existing message(s)")
        
        if items:
            print("\n📜 EXISTING MESSAGES:")
            print("=" * 50)
            
            for i, item in enumerate(items, 1):
                text = get_value(item, 'text')
                sender = get_value(item, 'sender')
                time_str = get_value(item, 'time')
                key = get_value(item, 'key')
                user_id = get_value(item, 'userID')
                
                print(f"{i}. 📨 Message ID: {key}")
                print(f"   From: {sender}")
                print(f"   Text: {text}")
                print(f"   Time: {time_str}")
                print(f"   User: {user_id}")
                print("-" * 30)
            
            print("=" * 50)
        else:
            print("📭 No existing messages found")
        
        return items
        
    except Exception as e:
        print(f"❌ Error querying existing messages: {e}")
        return []


def monitor_messages_table():
    """Monitor the 'messages' table for new entries using polling approach."""
    
    # AWS configuration
    ACCESS_KEY = ""
    SECRET_KEY = ""
    REGION = 'us-east-2'
    TABLE_NAME = "messages"
    POLL_INTERVAL = 5  # seconds between checks
    
    print(f"🔍 Starting monitor for table '{TABLE_NAME}'...")
    print(f"⏱️  Polling interval: {POLL_INTERVAL} seconds")
    
    # Initialize AWS client
    dynamodb = boto3.client(
        'dynamodb',
        region_name=REGION,
        aws_access_key_id=ACCESS_KEY,
        aws_secret_access_key=SECRET_KEY
    )
    
    # Track previously seen message IDs
    seen_message_ids = set()
    
    # Initial query to get existing messages
    print("\n📋 Initial scan of existing messages:")
    existing_messages = query_existing_messages(dynamodb, TABLE_NAME)
    
    # Add existing message IDs to our tracking set
    for item in existing_messages:
        key = get_value(item, 'key')
        if key:
            seen_message_ids.add(key)
    
    print(f"\n🎯 Starting polling monitor... (tracking {len(seen_message_ids)} existing messages)")
    print("Press Ctrl+C to stop\n")
    
    try:
        while True:
            try:
                # Query current messages (without printing them)
                response = dynamodb.scan(TableName=TABLE_NAME)
                current_messages = response.get('Items', [])
                
                # Check for new messages
                new_messages = []
                current_message_ids = set()
                
                for item in current_messages:
                    key = get_value(item, 'key')
                    if key:
                        current_message_ids.add(key)
                        if key not in seen_message_ids:
                            new_messages.append(item)
                
                # Report new messages
                if new_messages:
                    print(f"\n🚨 DETECTED {len(new_messages)} NEW MESSAGE(S)!")
                    print("=" * 50)
                    
                    for i, item in enumerate(new_messages, 1):
                        text = get_value(item, 'text')
                        sender = get_value(item, 'sender')
                        time_str = get_value(item, 'time')
                        key = get_value(item, 'key')
                        user_id = get_value(item, 'userID')
                        
                        print(f"🆕 NEW MESSAGE #{i}:")
                        print(f"   ID: {key}")
                        print(f"   From: {sender}")
                        print(f"   Text: {text}")
                        print(f"   Time: {time_str}")
                        print(f"   User: {user_id}")
                        print("-" * 30)
                        
                        # Add to seen messages
                        if key:
                            seen_message_ids.add(key)
                    
                    print("=" * 50)
                    print(f"� Total tracked messages: {len(seen_message_ids)}")
                else:
                    print(f"{datetime.now().strftime('%H:%M:%S')}")
                
                # Check for deleted messages (optional)
                deleted_count = len(seen_message_ids - current_message_ids)
                if deleted_count > 0:
                    print(f"🗑️  {deleted_count} message(s) were deleted")
                    # Remove deleted messages from tracking
                    seen_message_ids = current_message_ids
                
                # Wait before next poll
                time.sleep(POLL_INTERVAL)
                
            except Exception as e:
                print(f"⚠️ Error during polling: {e}. Retrying in {POLL_INTERVAL} seconds...")
                time.sleep(POLL_INTERVAL)
                continue
                
    except KeyboardInterrupt:
        print("\n👋 Stopping monitor...")
        print(f"📊 Final count: {len(seen_message_ids)} messages tracked")
    except Exception as e:
        print(f"❌ Error: {e}")


if __name__ == "__main__":
    monitor_messages_table()