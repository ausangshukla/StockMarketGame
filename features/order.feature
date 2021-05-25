Feature: Order
    In order to generate trades from orders placed
    Orders must match in the order book
        
    Scenario Outline: Cross Market Order with Limit Order
        Given there is a market order "<market order>"
        Given there is a limit order "<limit order>"
        And the market order is crossed with the limit order   
        Then I should see a new trade "<trade>"
        And the trade should have the right buyer and seller
        And the order status must be updated correctly
    Examples:
        |market order                                          |limit order                                                        |trade                                     |
        |price_type=Marker;security_id=1;quantity=100;side=B   |price_type=Limit;security_id=1;quantity=100;price=30;side=S   |security_id=1;quantity=100;price=30       |
        |price_type=Marker;security_id=1;quantity=20;side=B    |price_type=Limit;security_id=1;quantity=100;price=30;side=S   |security_id=1;quantity=20;price=30       |
        |price_type=Marker;security_id=1;quantity=100;side=S   |price_type=Limit;security_id=1;quantity=20;price=30;side=B   |security_id=1;quantity=20;price=30       |