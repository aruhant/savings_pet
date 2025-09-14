"""Portfolio analysis using volatility-based routing to generate performance commentary."""

import numpy as np
from typing import Dict, Any
from stream_listener import Portfolio  # Assuming Portfolio is in stream_listener.py
from deimos_router import Router, register_rule
from deimos_router.rules.volatility_rule import VolatilityRule
from deimos_router.config import config
import openai


def compute_volatility(portfolio: Portfolio) -> float:
    """Compute standard deviation of returns from trailing and calendar returns."""
    returns = []
    
    # Extract numerical values from trailing_returns
    for key, value in portfolio.trailing_returns.items():
        try:
            returns.append(float(value))
        except ValueError:
            pass
    
    # Extract numerical values from calendar_returns
    for key, value in portfolio.calendar_returns.items():
        try:
            returns.append(float(value))
        except ValueError:
            pass
    
    if len(returns) < 2:
        return 0.0  # No volatility if insufficient data
    
    return np.std(returns)


def generate_commentary(portfolio: Portfolio, model: str) -> str:
    """Generate AI commentary on portfolio performance using the selected model."""
    if not config.is_configured():
        return "Error: Router config not set up."
    
    credentials = config.get_credentials()
    client = openai.OpenAI(
        api_key=credentials['api_key'],
        base_url=credentials.get('api_url')
    )
    
    # Prepare prompt with portfolio data
    prompt = f"""
    Analyze the following portfolio performance data and provide a concise commentary on its performance, risks, and trends.

    Portfolio ID: {portfolio.portfolio_id}
    Trailing Returns: {portfolio.trailing_returns}
    Calendar Returns: {portfolio.calendar_returns}

    Focus on volatility, potential gains/losses, and recommendations. Keep it under 200 words.
    """
    
    try:
        response = client.chat.completions.create(
            model=model,
            messages=[{"role": "user", "content": prompt}],
            max_tokens=300,
            temperature=0.7
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        return f"Error generating commentary: {str(e)}"


def analyze_portfolio(portfolio: Portfolio) -> str:
    """Analyze portfolio using volatility router and generate commentary."""
    # Compute volatility
    volatility = compute_volatility(portfolio)
    print(f"Computed volatility for {portfolio.portfolio_id}: {volatility:.2f}")
    
    # Set up VolatilityRule (adjust thresholds/models as needed)
    vol_rule = VolatilityRule(
        name="portfolio-volatility",
        low_vol_threshold=0.05,    # Low if std dev <= 0.05
        high_vol_threshold=0.20,   # High if std dev >= 0.20
        low_vol_model="gpt-3.5-turbo",      # Cheap for stable portfolios
        medium_vol_model="gpt-4o-mini",     # Balanced for moderate
        high_vol_model="gpt-4",             # Powerful for volatile
        default="gpt-3.5-turbo"
    )
    register_rule(vol_rule)
    
    # Create router
    router = Router(name="portfolio-router", rules=[vol_rule], default="gpt-3.5-turbo")
    
    # Select model based on volatility
    request_data = {"series": list(portfolio.trailing_returns.values()) + list(portfolio.calendar_returns.values())}
    selected_model = router.select_model(request_data)
    print(f"Selected model: {selected_model}")
    
    # Generate commentary
    commentary = generate_commentary(portfolio, selected_model)
    return commentary


# Example usage
if __name__ == "__main__":
    # Sample portfolio data
    sample_portfolio = Portfolio(
        portfolio_id="PORT-123",
        trailing_returns={"1M": "0.02", "3M": "0.05", "6M": "0.08"},
        calendar_returns={"2023": "0.10", "2024": "0.12"}
    )
    
    commentary = analyze_portfolio(sample_portfolio)
    print("\nPortfolio Commentary:")
    print(commentary)