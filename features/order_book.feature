Feature: Order Book
    In order to generate trades from orders placed
    Orders must match in the order book
        
    Scenario Outline: Cross Market Order with Limit Order
        Given there are two limit orders "<limit order 1>" "<limit order 2>"
        And the order book is created for "<limit order 1>"   
        Then I should see a new trade "<trade>"
        And the order status must be updated correctly
    Examples:
        |limit order 1                                                  |limit order 2                                                   |trade                                     |
        |price_type=Limit;security_id=1;quantity=100;price=20;side=B    |price_type=Limit;security_id=1;quantity=100;price=20;side=S   |security_id=1;quantity=100;price=20      |



    Scenario Outline: Cross Market Order with Limit Order
        Given there are two limit orders "<limit order 1>" "<limit order 2>"
        And the order book is created for "<limit order 1>"   
        Then I should see no new trade created
    Examples:
        |limit order 1                                                  |limit order 2                                                 |
        |price_type=Limit;security_id=1;quantity=100;price=20;side=B    |price_type=Limit;security_id=1;quantity=100;price=30;side=S   |
        |price_type=Limit;security_id=1;quantity=100;price=30;side=S    |price_type=Limit;security_id=1;quantity=100;price=20;side=B   |
        |price_type=Limit;security_id=1;quantity=100;price=20;side=S    |price_type=Limit;security_id=1;quantity=100;price=20;side=S   |
