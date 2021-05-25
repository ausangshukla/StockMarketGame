Given('there is a user {string}') do |arg1|
  @user = FactoryBot.build(:user)
  key_values(@user, arg1)
  @user.save!
  log "\n####User####\n"
  log @user.to_json
end


Given('there is a market order {string}') do |arg1|
  @market_order = FactoryBot.build(:order)
  key_values(@market_order, arg1)
  @market_order.user_id ||= User.all.shuffle[0].id 
  @market_order.save!
  log "\n####Market Order####\n"
  log @market_order.to_json
end


Given('there is a limit order {string}') do |arg1|
    @limit_order = FactoryBot.build(:order)
    key_values(@limit_order, arg1)
    @limit_order.user_id ||= User.all.shuffle[0].id
    @limit_order.save!
    log "\n####Limit Order####\n"
    log @limit_order.to_json
end
  

Given('there are two limit orders {string} {string}') do |arg1, arg2|
    steps %Q{
        Given there is a limit order '#{arg1}'
        Given there is a limit order '#{arg2}'
    }
    @limit_order_1 = Order.first 
    @limit_order_2 = Order.last 
end

Given('the limit orders are crossed') do
    @limit_order_1.cross(@limit_order_2)
end
  
  