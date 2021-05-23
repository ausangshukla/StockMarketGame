namespace :smg do
    desc "Create fake users"
    task :create_users => :environment do
        (1..10).each do
            u = FactoryBot.create(:user)
            (0..15).each do
                w = FactoryBot.create(:security)
            end
            (0..15).each do
                w = FactoryBot.create(:news)
            end
            (0..15).each do
                user = User.all.shuffle[0]
                sec = Security.all.shuffle[0]
                w = FactoryBot.create(:order, user_id: user.id, security_id: sec.id, symbol: sec.symbol )
            end
            
        end
    end

    
end
