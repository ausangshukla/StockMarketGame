module OrderBookConcern
    extend ActiveSupport::Concern
  
    class_methods do

        def broadcast(entity)

            name = entity.class.name.underscore
    
            ActionCable.server.broadcast "order_book:security_id:#{entity.security_id}", 
                {   id: entity.id,
                    type: name,
                    data: entity.to_json,
                    html: ApplicationController.render("/#{name.pluralize}/_row", layout:nil, locals: {"#{name}": entity})
                }
        end
    

        def valid_cross?(new_order, existing_order)
            valid = false
            if( new_order.fill_status != Order::FILLED && # The new order is not already filled
                existing_order.fill_status != Order::FILLED &&
                
                new_order.status == Order::OPEN && # Order is still open
                existing_order.status == Order::OPEN &&
                
                new_order.side != existing_order.side && # the 2 orders are on opposite sides B/S
                new_order.security_id == existing_order.security_id ) # Both are for the same security

                if(new_order.price_type == Order::MARKET && existing_order.price_type == Order::MARKET)
                    # Cannot cross 2 market orders
                    valid = false
                elsif(new_order.price_type == Order::LIMIT && existing_order.price_type == Order::LIMIT)
                    # If both are limit orders, the buy price must be > sell price
                    valid = (new_order.side == Order::BUY) ? new_order.price >= existing_order.price : new_order.price <= existing_order.price 
                else
                    # Cleared all other criteria, so we can cross
                    valid = true
                end
                
            end
            valid
        end

        # Cross this order with the input order
        def cross(new_order, existing_order)
            # ensure the right sides
            if(valid_cross?(new_order, existing_order))
                
                price = getPrice(new_order, existing_order)        

                buy_order, sell_order = (new_order.side == Order::BUY) ? [new_order, existing_order] : [existing_order, new_order]
                trade_quantity = (buy_order.open_qty <= sell_order.open_qty) ? buy_order.open_qty : sell_order.open_qty

                Trade.transaction do
                    # Create the trade
                    buy_trade = Trade.create(   symbol: new_order.symbol,
                                                quantity: trade_quantity,
                                                price: price, 
                                                side: buy_order.side,
                                                security_id: buy_order.security_id, 
                                                user_id: buy_order.user_id,
                                                order_id: buy_order.id, 
                                                counterparty_order_id: sell_order.id )
                    
                    sell_trade = Trade.create(  symbol: new_order.symbol,
                                                quantity: trade_quantity,
                                                price: price, 
                                                side: sell_order.side,
                                                security_id: sell_order.security_id, 
                                                user_id: sell_order.user_id,
                                                order_id: sell_order.id, 
                                                counterparty_order_id: buy_order.id )
                    
                    # Update the orders
                    buy_order.filled_qty += trade_quantity
                    buy_order.save

                    sell_order.filled_qty += trade_quantity
                    sell_order.save
                end

                return true
            else
                logger.debug "Orders cross not valid #{new_order} and #{existing_order}"
                return false
            end
        end
        

        # See how it works. https://medium.com/reactivemarkets/limit-order-books-9d48adf2c517
        def getPrice(new_order, existing_order)
            price_types = [new_order.price_type, existing_order.price_type]

            return case price_types
                when [Order::MARKET, Order::LIMIT]; existing_order.price
                when [Order::LIMIT, Order::MARKET]; new_order.price
                when [Order::LIMIT, Order::LIMIT]; existing_order.price # See Price taking https://medium.com/reactivemarkets/limit-order-books-9d48adf2c517
                when [Order::MARKET, Order::MARKET]; new_order.security.price
                else; 0
            end
        end


        def print_book(security, limit_buys, limit_sells, price_type)        

            table = Terminal::Table.new title: "#{security.symbol} : #{security.id} : #{price_type} Order Book"  do |rows|
                rows << ["Order Id", "Buy Quantity", "Buy Price", "Order Id", "Sell Quantity", "Sell Price"]
                rows << :separator  
    
                buys_sells = limit_buys.count > limit_sells.count ? limit_buys.zip(limit_sells) : limit_sells.zip(limit_buys).map(&:reverse) 
    
                buys_sells.each do |b,s|
                    # puts "Processing #{b}, #{s}"
                    row = []
                    b ? row.concat([b.id, b.open_qty, b.price]) : row.concat([" ", " ", " "])
                    s ? row.concat([s.id, s.open_qty, s.price]) : row.concat([" ", " ", " "])
                    rows << row
                end 
            end
    
            puts table
        end

    end
end