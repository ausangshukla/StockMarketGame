class OrderSimulator
    def self.simulate(security_id, exchange="NYSE", count=20, sleep_time=5)
        users = User.where(role: "Simulator")
        securities = Security.all

        (1..count).each do
        
            user_id = users.shuffle[0].id 
            security_id ||= securities.shuffle[0].id
            
            order = FactoryBot.create(:order, user_id: user_id, 
                security_id: security_id,
                price_type: rand(10) > 4 ? "Limit" : "Market")

            Exchange.publish(exchange, order)
            
            sleep(sleep_time)
        end
    end

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