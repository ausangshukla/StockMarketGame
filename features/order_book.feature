Feature: Order Book
    In order to generate trades from orders placed
    Orders must match in the order book
        
    Scenario Outline: Cross Limit Order with Limit Order
        Given there are two orders "<order 1>" "<order 2>"
        And the order book is created for "<order 1>"   
        Then I should see a new trade "<trade>"
        And the order status must be updated correctly
    Examples:
        |order 1                                                        |order 2                                                   |trade                                     |
        |price_type=Limit;security_id=1;quantity=100;price=20;side=B    |price_type=Limit;security_id=1;quantity=100;price=20;side=S   |security_id=1;quantity=100;price=20      |



    Scenario Outline: Cross Limit Order with non matching Limit Order
        Given there are two orders "<order 1>" "<order 2>"
        And the order book is created for "<order 1>"   
        Then I should see no new trade created
    Examples:
        |order 1                                                        |order 2                                                 |
        |price_type=Limit;security_id=1;quantity=100;price=20;side=B    |price_type=Limit;security_id=1;quantity=100;price=30;side=S   |
        |price_type=Limit;security_id=1;quantity=100;price=30;side=S    |price_type=Limit;security_id=1;quantity=100;price=20;side=B   |
        |price_type=Limit;security_id=1;quantity=100;price=20;side=S    |price_type=Limit;security_id=1;quantity=100;price=20;side=S   |
        |price_type=Market;security_id=1;quantity=100;price=20;side=S   |price_type=Market;security_id=1;quantity=100;price=20;side=B   |



    Scenario Outline: Cross Market Order with multiple Limit Order
        Given there are two orders "<limit order 1>" "<limit order 2>"
        Given there is a market order "<market order>"
        And the order book is created for "<limit order 1>"   
        Then I should see "2" new trades created
        And the trade quantities should match the order filled quantity
    Examples:
        |market order                                           |limit order 1                                                  |limit order 2                                                 |
        |price_type=Market;security_id=1;quantity=100;side=B    |price_type=Limit;security_id=1;quantity=50;price=20;side=S    |price_type=Limit;security_id=1;quantity=50;price=30;side=S   |
        |price_type=Market;security_id=1;quantity=100;side=B    |price_type=Limit;security_id=1;quantity=50;price=30;side=S    |price_type=Limit;security_id=1;quantity=70;price=20;side=S   |
        |price_type=Market;security_id=1;quantity=100;side=B    |price_type=Limit;security_id=1;quantity=70;price=20;side=S    |price_type=Limit;security_id=1;quantity=50;price=20;side=S   |
        |price_type=Market;security_id=1;quantity=200;side=B    |price_type=Limit;security_id=1;quantity=70;price=20;side=S    |price_type=Limit;security_id=1;quantity=50;price=20;side=S   |
