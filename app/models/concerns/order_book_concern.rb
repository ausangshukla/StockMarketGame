module OrderBookConcern
    extend ActiveSupport::Concern
  
    class_methods do

        def valid_cross?(new_order, existing_order)
            valid = false
            if( new_order.fill_status != Order::FILLED && # The new order is not already filled
                existing_order.fill_status != Order::FILLED &&
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
                
                trade_quantity = (new_order.open_qty <= existing_order.open_qty) ? new_order.open_qty : existing_order.open_qty
                buyer_id = new_order.side == Order::BUY ? new_order.user_id : existing_order.user_id
                seller_id = new_order.side == Order::SELL ? new_order.user_id : existing_order.user_id
                price = getPrice(new_order, existing_order)        

                Trade.transaction do
                    
                    # Create the trade
                    trade = Trade.new(order_id: new_order.id, symbol: new_order.symbol,
                        security_id: new_order.security_id, quantity: trade_quantity,
                        price: price, 
                        buyer_id: buyer_id,
                        seller_id: seller_id, 
                        counterparty_order_id: existing_order.id)
                    trade.save
                    
                    # Update the orders
                    new_order.filled_qty += trade_quantity
                    new_order.save

                    existing_order.filled_qty += trade_quantity
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