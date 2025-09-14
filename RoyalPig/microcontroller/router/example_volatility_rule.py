"""Example demonstrating volatility-based routing."""

from deimos_router import Router, register_rule
from deimos_router.rules.volatility_rule import VolatilityRule

def main():
    # Create volatility rule
    vol_rule = VolatilityRule(
        name="volatility-router",
        low_vol_threshold=0.5,    # Low if std dev <= 0.5
        high_vol_threshold=2.0,   # High if std dev >= 2.0
        low_vol_model="gpt-3.5-turbo",      # Cheap model for stable data
        medium_vol_model="gpt-4o-mini",     # Balanced for moderate volatility
        high_vol_model="gpt-4",             # Powerful for volatile data
        default="gpt-3.5-turbo"
    )
    register_rule(vol_rule)
    
    # Create router
    router = Router(name="volatility-router", rules=[vol_rule], default="gpt-3.5-turbo")
    
    # Test cases with different volatilities
    test_cases = [
        {"series": [1.0, 1.1, 1.0, 1.05, 1.02], "desc": "Low volatility (stable)"},
        {"series": [1.0, 1.5, 0.8, 1.3, 1.1], "desc": "Medium volatility"},
        {"series": [1.0, 3.0, 0.5, 2.5, 0.2], "desc": "High volatility"},
        {"series": [], "desc": "Invalid series"}
    ]
    
    for i, case in enumerate(test_cases, 1):
        model = router.select_model(case)
        print(f"Test {i}: {case['desc']} -> {model}")

if __name__ == "__main__":
    main()