"""Script to analyze portfolios and update results in DynamoDB."""

import boto3
from typing import List
from stream_listener import Portfolio, DynamoStreamListener
from analysis import compute_volatility, generate_commentary, analyze_portfolio
from deimos_router import Router, register_rule
from deimos_router.rules.volatility_rule import VolatilityRule


def update_portfolio_in_db(dynamodb_client, table_name: str, portfolio: Portfolio, volatility: float, selected_model: str, commentary: str):
    """Update a portfolio in DynamoDB with analysis results."""
    try:
        response = dynamodb_client.update_item(
            TableName=table_name,
            Key={
                'portfolioId': {'S': portfolio.portfolio_id}
            },
            UpdateExpression="SET #vol = :vol, #model = :model, #comm = :comm",
            ExpressionAttributeNames={
                '#vol': 'volatility',
                '#model': 'selected_model',
                '#comm': 'commentary'
            },
            ExpressionAttributeValues={
                ':vol': {'N': str(volatility)},
                ':model': {'S': selected_model},
                ':comm': {'S': commentary}
            },
            ReturnValues="UPDATED_NEW"
        )
        print(f"Updated portfolio {portfolio.portfolio_id}: {response.get('Attributes', {})}")
    except Exception as e:
        print(f"Error updating portfolio {portfolio.portfolio_id}: {e}")


def main(table_name: str = "portfolios", region: str = "us-east-2"):
    """Main function to fetch, analyze, and update portfolios."""
    # Initialize DynamoDB client
    dynamodb = boto3.client('dynamodb', region_name=region)
    
    # Fetch all portfolios
    listener = DynamoStreamListener(table_name, region=region)
    portfolios = listener.get_current_items()
    
    if not portfolios:
        print("No portfolios found in the table.")
        return
    
    # Set up VolatilityRule for analysis (reuse from analysis.py)
    vol_rule = VolatilityRule(
        name="portfolio-volatility",
        low_vol_threshold=0.05,
        high_vol_threshold=0.20,
        low_vol_model="gpt-3.5-turbo",
        medium_vol_model="gpt-4o-mini",
        high_vol_model="gpt-4",
        default="gpt-3.5-turbo"
    )
    register_rule(vol_rule)
    
    router = Router(name="portfolio-router", rules=[vol_rule], default="gpt-3.5-turbo")
    
    for portfolio in portfolios:
        print(f"Analyzing portfolio: {portfolio.portfolio_id}")
        
        # Compute volatility
        volatility = compute_volatility(portfolio)
        if volatility == 0.0:
            print(f"Skipping {portfolio.portfolio_id}: insufficient data.")
            continue
        
        # Select model via router
        request_data = {"series": list(portfolio.trailing_returns.values()) + list(portfolio.calendar_returns.values())}
        selected_model = router.select_model(request_data)
        
        # Generate commentary
        commentary = generate_commentary(portfolio, selected_model)
        
        # Update DynamoDB
        update_portfolio_in_db(dynamodb, table_name, portfolio, volatility, selected_model, commentary)


if __name__ == "__main__":
    main()