import rpi_gpio as GPIO
import time
import threading
from enum import Enum
from datetime import datetime, timedelta


class PigMood(Enum):
    """Enum representing different pig moods"""
    HAPPY = "happy"
    SAD = "sad"
    NEUTRAL = "neutral"
    EXCITED = "excited"
    DISAPPOINTED = "disappointed"


class SavingsPig:
    """
    An object-oriented savings pig that responds to financial behavior.
    The pig's mood changes based on savings vs spending patterns.
    """
    
    def __init__(self, 
                 savings_threshold=100.0,
                 spending_threshold=200.0,
                 mood_decay_hours=24):
        """
        Initialize the savings pig.
        
        Args:
            savings_threshold: Amount that makes pig happy
            spending_threshold: Amount that makes pig sad
            mood_decay_hours: Hours until mood returns to neutral
        """
        # Hardware pin setup (BCM pin numbers)
        self.HEAD_SERV_PIN = 12
        self.BASE_SERV_PIN = 13
        self.GREEN_LED_PIN = 16
        self.RED_LED_PIN = 19
        self.SPEAKER_PIN = 18
        
        # Pig state
        self.mood = PigMood.NEUTRAL
        self.last_mood_change = datetime.now()
        self.total_savings = 0.0
        self.total_spending = 0.0
        self.daily_balance = 0.0
        
        # Thresholds for mood changes
        self.savings_threshold = savings_threshold
        self.spending_threshold = spending_threshold
        self.mood_decay_hours = mood_decay_hours
        
        # Hardware setup
        self._setup_hardware()
        
        print(f"🐷 Savings Pig initialized!")
        print(f"   Savings threshold: ${savings_threshold}")
        print(f"   Spending threshold: ${spending_threshold}")
        print(f"   Mood: {self.mood.value}")
    
    def _setup_hardware(self):
        """Initialize GPIO pins and PWM for servos"""
        GPIO.setmode(GPIO.BCM)
        
        # Configure pins
        GPIO.setup(self.BASE_SERV_PIN, GPIO.OUT)
        GPIO.setup(self.HEAD_SERV_PIN, GPIO.OUT)
        GPIO.setup(self.GREEN_LED_PIN, GPIO.OUT)
        GPIO.setup(self.RED_LED_PIN, GPIO.OUT)
        GPIO.setup(self.SPEAKER_PIN, GPIO.OUT)
        
        # Init PWM for servos
        self.pwm_base = GPIO.PWM(self.BASE_SERV_PIN, 50, mode=GPIO.PWM.MODE_MS)
        self.pwm_head = GPIO.PWM(self.HEAD_SERV_PIN, 50, mode=GPIO.PWM.MODE_MS)
        self.pwm_base.start(0)
        self.pwm_head.start(0)
        
        # Set to neutral position
        self._set_neutral_position()
    
    def process_transaction(self, amount, transaction_type):
        """
        Process a new transaction and update pig's mood.
        
        Args:
            amount: Transaction amount (positive number)
            transaction_type: 'income' or 'expense'
        """
        print(f"\n💰 Processing transaction: {transaction_type} ${amount:.2f}")
        
        if transaction_type == 'income':
            self.total_savings += amount
            self.daily_balance += amount
            print(f"   💚 Savings increased! Total: ${self.total_savings:.2f}")
            
            if amount >= self.savings_threshold:
                self._change_mood(PigMood.EXCITED if amount >= self.savings_threshold * 2 else PigMood.HAPPY)
        
        elif transaction_type == 'expense':
            self.total_spending += amount
            self.daily_balance -= amount
            print(f"   💸 Spending recorded! Total: ${self.total_spending:.2f}")
            
            if amount >= self.spending_threshold:
                self._change_mood(PigMood.DISAPPOINTED if amount >= self.spending_threshold * 2 else PigMood.SAD)
        
        print(f"   📊 Daily balance: ${self.daily_balance:+.2f}")
        print(f"   🐷 Pig mood: {self.mood.value}")
        
        # Perform mood-based behavior
        self._express_mood()
    
    def _change_mood(self, new_mood):
        """Change the pig's mood and record timestamp"""
        if self.mood != new_mood:
            old_mood = self.mood.value
            self.mood = new_mood
            self.last_mood_change = datetime.now()
            print(f"   🎭 Mood changed: {old_mood} → {new_mood.value}")
    
    def _check_mood_decay(self):
        """Check if mood should decay back to neutral over time"""
        time_since_change = datetime.now() - self.last_mood_change
        if time_since_change > timedelta(hours=self.mood_decay_hours):
            if self.mood != PigMood.NEUTRAL:
                print(f"   ⏰ Mood decaying to neutral after {self.mood_decay_hours} hours")
                self._change_mood(PigMood.NEUTRAL)
    
    def _express_mood(self):
        """Express the current mood through hardware actions"""
        self._check_mood_decay()
        
        if self.mood == PigMood.HAPPY:
            self._perform_happy_behavior()
        elif self.mood == PigMood.EXCITED:
            self._perform_excited_behavior()
        elif self.mood == PigMood.SAD:
            self._perform_sad_behavior()
        elif self.mood == PigMood.DISAPPOINTED:
            self._perform_disappointed_behavior()
        else:  # NEUTRAL
            self._perform_neutral_behavior()
    
    def _perform_happy_behavior(self):
        """Happy pig behavior: green light, upright, gentle nods, happy tune"""
        print("   😊 Expressing happiness!")
        GPIO.output(self.GREEN_LED_PIN, GPIO.HIGH)
        GPIO.output(self.RED_LED_PIN, GPIO.LOW)
        self._stand_up()
        
        # Gentle head nods + happy tune in parallel
        t1 = threading.Thread(target=self._gentle_head_nods)
        t2 = threading.Thread(target=self._play_happy_tune)
        t1.start()
        t2.start()
        t1.join()
        t2.join()
    
    def _perform_excited_behavior(self):
        """Excited pig behavior: flashing lights, energetic movements"""
        print("   🤩 Expressing excitement!")
        
        # Flashing lights
        for _ in range(5):
            GPIO.output(self.GREEN_LED_PIN, GPIO.HIGH)
            time.sleep(0.2)
            GPIO.output(self.GREEN_LED_PIN, GPIO.LOW)
            time.sleep(0.2)
        
        GPIO.output(self.GREEN_LED_PIN, GPIO.HIGH)
        self._stand_up()
        
        # Enthusiastic head movements + celebratory tune
        t1 = threading.Thread(target=self._enthusiastic_head_moves)
        t2 = threading.Thread(target=self._play_celebration_tune)
        t1.start()
        t2.start()
        t1.join()
        t2.join()
    
    def _perform_sad_behavior(self):
        """Sad pig behavior: red light, lying down, slow movements, sad tune"""
        print("   😢 Expressing sadness...")
        GPIO.output(self.RED_LED_PIN, GPIO.HIGH)
        GPIO.output(self.GREEN_LED_PIN, GPIO.LOW)
        self._lay_down()
        self._head_down()
        self._play_sad_tune()
    
    def _perform_disappointed_behavior(self):
        """Disappointed pig behavior: slow red pulses, drooping"""
        print("   😞 Expressing disappointment...")
        
        # Slow red pulses
        for _ in range(3):
            GPIO.output(self.RED_LED_PIN, GPIO.HIGH)
            time.sleep(0.5)
            GPIO.output(self.RED_LED_PIN, GPIO.LOW)
            time.sleep(0.5)
        
        GPIO.output(self.RED_LED_PIN, GPIO.HIGH)
        self._lay_down()
        self._head_down()
        self._play_disappointed_tune()
    
    def _perform_neutral_behavior(self):
        """Neutral pig behavior: no lights, normal position"""
        print("   😐 Neutral state")
        GPIO.output(self.GREEN_LED_PIN, GPIO.LOW)
        GPIO.output(self.RED_LED_PIN, GPIO.LOW)
        self._set_neutral_position()
    
    # Hardware control methods
    def _set_angle(self, pwm, angle):
        """Set servo angle (0-180 degrees)"""
        MIN_DUTY_CYCLE = 2.5
        MAX_DUTY_CYCLE = 12.5
        duty = MIN_DUTY_CYCLE + ((angle * (MAX_DUTY_CYCLE - MIN_DUTY_CYCLE)) / 180.0)
        pwm.ChangeDutyCycle(duty)
        time.sleep(0.05)
    
    def _head_up(self):
        self._set_angle(self.pwm_head, 130)
    
    def _head_down(self):
        self._set_angle(self.pwm_head, 160)
    
    def _stand_up(self):
        self._set_angle(self.pwm_base, 35)
    
    def _lay_down(self):
        self._set_angle(self.pwm_base, 20)
    
    def _set_neutral_position(self):
        self._set_angle(self.pwm_base, 30)
        self._set_angle(self.pwm_head, 145)
    
    def _gentle_head_nods(self):
        """Gentle head nodding for happy mood"""
        for _ in range(3):
            for ang in range(130, 161, 2):
                self._set_angle(self.pwm_head, ang)
                time.sleep(0.03)
            for ang in range(160, 129, -2):
                self._set_angle(self.pwm_head, ang)
                time.sleep(0.03)
        self._head_up()
    
    def _enthusiastic_head_moves(self):
        """Energetic head movements for excited mood"""
        for _ in range(5):
            for ang in range(130, 161, 5):
                self._set_angle(self.pwm_head, ang)
                time.sleep(0.01)
            for ang in range(160, 129, -5):
                self._set_angle(self.pwm_head, ang)
                time.sleep(0.01)
        self._head_up()
    
    # Audio methods
    def _play_melody(self, melody):
        """Play a melody given as list of (frequency, duration) tuples"""
        for freq, dur in melody:
            half_period = 1.0 / (2 * freq)
            end_time = time.time() + dur
            while time.time() < end_time:
                GPIO.output(self.SPEAKER_PIN, GPIO.HIGH)
                time.sleep(half_period)
                GPIO.output(self.SPEAKER_PIN, GPIO.LOW)
                time.sleep(half_period)
            time.sleep(0.05)
    
    def _play_happy_tune(self):
        melody = [
            (659, 0.3),  # E5
            (784, 0.3),  # G5
            (988, 0.3),  # B5
            (1319, 0.4), # E6
            (988, 0.3),  # B5
            (1319, 0.6), # E6
        ]
        self._play_melody(melody)
    
    def _play_celebration_tune(self):
        melody = [
            (523, 0.2),  # C5
            (659, 0.2),  # E5
            (784, 0.2),  # G5
            (1047, 0.2), # C6
            (1319, 0.4), # E6
            (1568, 0.4), # G6
            (2093, 0.6), # C7
        ]
        self._play_melody(melody)
    
    def _play_sad_tune(self):
        melody = [
            (392, 0.5),  # G4
            (370, 0.5),  # F#4
            (349, 0.7),  # F4
            (330, 0.8),  # E4
            (294, 0.7),  # D4
            (262, 0.9),  # C4
        ]
        self._play_melody(melody)
    
    def _play_disappointed_tune(self):
        melody = [
            (220, 0.8),  # A3
            (196, 0.8),  # G3
            (175, 0.8),  # F3
            (147, 1.2),  # D3
        ]
        self._play_melody(melody)
    
    def get_status(self):
        """Get current pig status"""
        return {
            'mood': self.mood.value,
            'total_savings': self.total_savings,
            'total_spending': self.total_spending,
            'daily_balance': self.daily_balance,
            'last_mood_change': self.last_mood_change.isoformat()
        }
    
    def reset_daily_balance(self):
        """Reset daily balance (call this daily)"""
        print(f"📅 Resetting daily balance (was ${self.daily_balance:+.2f})")
        self.daily_balance = 0.0
    
    def cleanup(self):
        """Clean up GPIO resources"""
        print("🧹 Cleaning up pig hardware...")
        self.pwm_base.stop()
        self.pwm_head.stop()
        GPIO.cleanup()


# Factory function to create pig from stream data
def create_pig_from_stream_data(log_entry):
    """
    Create appropriate transaction data from stream log entry.
    
    Args:
        log_entry: LogEntry object from stream listener
    
    Returns:
        tuple: (amount, transaction_type) or None if not a transaction
    """
    if not log_entry.amount or not log_entry.type:
        return None
    
    transaction_type = 'income' if log_entry.type == 'income' else 'expense'
    return (log_entry.amount, transaction_type)


# Example usage and testing
if __name__ == "__main__":
    # Create pig instance
    pig = SavingsPig(
        savings_threshold=50.0,    # $50 makes pig happy
        spending_threshold=100.0,  # $100 makes pig sad
        mood_decay_hours=1         # 1 hour for testing
    )
    
    try:
        # Interactive testing
        print("\n🎮 Interactive Pig Testing")
        print("Commands: income <amount>, expense <amount>, status, reset, quit")
        
        while True:
            cmd = input("\nEnter command: ").strip().lower()
            
            if cmd.startswith('income '):
                try:
                    amount = float(cmd.split()[1])
                    pig.process_transaction(amount, 'income')
                except (IndexError, ValueError):
                    print("Usage: income <amount>")
            
            elif cmd.startswith('expense '):
                try:
                    amount = float(cmd.split()[1])
                    pig.process_transaction(amount, 'expense')
                except (IndexError, ValueError):
                    print("Usage: expense <amount>")
            
            elif cmd == 'status':
                status = pig.get_status()
                print(f"\n📊 Pig Status:")
                for key, value in status.items():
                    print(f"   {key}: {value}")
            
            elif cmd == 'reset':
                pig.reset_daily_balance()
            
            elif cmd == 'quit':
                break
            
            else:
                print("Unknown command")
    
    except KeyboardInterrupt:
        print("\n🛑 Interrupted")
    
    finally:
        pig.cleanup()