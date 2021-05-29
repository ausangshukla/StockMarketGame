
class OrderSimulator


    def self.simulate(security_id, exchange="NYSE", count=20, sleep_time=5)
        # Only simulator users have enough cash to place infinite number of orders
        users = User.where(role: "Simulator")
        securities = Security.all

        (1..count).each do
            # Get a random user
            user_id = users.shuffle[0].id 
            # Get a random security if none has been specified
            security_id ||= securities.shuffle[0].id
            # Create an order - some Limit and some Market
            order = FactoryBot.create(:order, user_id: user_id, 
                security_id: security_id,
                price_type: rand(10) > 4 ? "Limit" : "Market")
            # Send it to be processed by the exchange
            Exchange.publish(exchange, order)
            # We dont want to produce too many orders quickly - so sleep here
            sleep(sleep_time)
        end
    end

    # @see Exchange.simulate(exchange_name, security_id, count)
    # This triggers a redis pub/sub which is received here as a hash
    def self.receive
        redis = Redis.new(timeout:0)
        redis.subscribe("simulator") do |on|
            on.message do |channel, msg|
                begin
                    sim = JSON.parse(msg)
                    puts sim
                    simulate(sim["security_id"], sim["exchange"], sim["count"])
                rescue => error
                    Rails.logger.debug error.backtrace
                end
            end
        end    
    end

end