class OrderSimulator
    def self.simulate(security_id, count=20, sleep_time=5)
        exchange = Exchange.get("NYSE")
        users = User.where(role: "Simulator")
        securities = Security.all

        (1..count).each do
        
            user_id = users.shuffle[0].id 
            security_id ||= securities.shuffle[0].id
            
            order = FactoryBot.create(:order, user_id: user_id, 
                security_id: security_id,
                price_type: rand(10) > 4 ? "Limit" : "Market")
            exchange.processOrder(order)
            
            sleep(sleep_time)
        end
    end
end