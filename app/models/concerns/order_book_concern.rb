module OrderBookConcern
    extend ActiveSupport::Concern
  
    class_methods do

        def valid_cross?(new_order, existing_order)
            valid = false
            if(new_order.side != existing_order.side && new_order.security_id == existing_order.security_id)
                # If both are limit orders, the buy price must be > sell price
                if(new_order.price_type == Order::LIMIT && existing_order.price_type == Order::LIMIT)
                    valid = (new_order.side == Order::BUY) ? new_order.price >= existing_order.price : new_order.price <= existing_order.price 
                else
                    valid = true
                end
            end
            valid
        end

        # Cross this order with the input order
        def cross(new_order, existing_order)
            # ensure the right sides
            if(valid_cross?(new_order, existing_order))
                
                quantity = (new_order.quantity <= existing_order.quantity) ? new_order.quantity : existing_order.quantity
                buyer_id = new_order.side == Order::BUY ? new_order.user_id : existing_order.user_id
                seller_id = new_order.side == Order::SELL ? new_order.user_id : existing_order.user_id
                price = getPrice(new_order, existing_order)        

                Trade.transaction do
                    
                    # Create the trade
                    trade = Trade.new(order_id: new_order.id, symbol: new_order.symbol,
                        security_id: new_order.security_id, quantity: quantity,
                        price: price, 
                        buyer_id: buyer_id,
                        seller_id: seller_id, 
                        counterparty_order_id: existing_order.id)
                    trade.save
                    
                    # Update the orders
                    new_order.filled_qty = quantity
                    new_order.save

                    existing_order.filled_qty = quantity
                    existing_order.save
                end

                return true
            else
                logger.debug "Orders cross not valid"
                return false
            end
        end

        def getPrice(new_order, existing_order)
            price_types = [new_order.price_type, existing_order.price_type]

            return case price_types
                when [Order::MARKET, Order::LIMIT]; existing_order.price
                when [Order::LIMIT, Order::MARKET]; new_order.price
                when [Order::LIMIT, Order::LIMIT]; new_order.id > existing_order.id ? new_order.price : existing_order.price
                when [Order::MARKET, Order::MARKET]; new_order.security.price
                else; 0
            end
        end

    end
end