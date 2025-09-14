"""Volatility-based routing rule using standard deviation."""

import numpy as np
from typing import Any, Dict, Optional
from .base import Rule, Decision


class VolatilityRule(Rule):
    """Rule that routes based on the volatility (standard deviation) of a numerical series."""
    
    def __init__(self, name: str, 
                 low_vol_threshold: float, 
                 high_vol_threshold: float,
                 low_vol_model: str, 
                 medium_vol_model: str, 
                 high_vol_model: str,
                 default: Optional[str] = None):
        """Initialize VolatilityRule.
        
        Args:
            name: Rule name
            low_vol_threshold: Max std dev for low volatility
            high_vol_threshold: Min std dev for high volatility
            low_vol_model: Model for low volatility
            medium_vol_model: Model for medium volatility
            high_vol_model: Model for high volatility
            default: Fallback model if series is invalid
        """
        super().__init__(name)
        self.low_vol_threshold = low_vol_threshold
        self.high_vol_threshold = high_vol_threshold
        self.low_vol_model = low_vol_model
        self.medium_vol_model = medium_vol_model
        self.high_vol_model = high_vol_model
        self.default = default
    
    def evaluate(self, request_data: Dict[str, Any]) -> Decision:
        """Evaluate volatility and select model."""
        series = request_data.get('series', [])
        if not isinstance(series, list) or len(series) < 2:
            return Decision(self.default, trigger="invalid_series")
        
        try:
            std_dev = np.std(series)
            if std_dev <= self.low_vol_threshold:
                return Decision(self.low_vol_model, trigger=f"low_volatility_{std_dev:.2f}")
            elif std_dev >= self.high_vol_threshold:
                return Decision(self.high_vol_model, trigger=f"high_volatility_{std_dev:.2f}")
            else:
                return Decision(self.medium_vol_model, trigger=f"medium_volatility_{std_dev:.2f}")
        except Exception:
            return Decision(self.default, trigger="computation_error")
    
    def __repr__(self) -> str:
        return f"VolatilityRule('{self.name}', low={self.low_vol_threshold}, high={self.high_vol_threshold})"