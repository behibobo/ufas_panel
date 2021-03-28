# uri = URI.parse("https://restcountries.eu/rest/v2/all")

#         response = Net::HTTP.get_response(uri)
#         hash = JSON.parse(response.body)
#         Country.destroy_all
#         hash.each do |c|
#             Country.create(name: c["name"], region: c["region"], code: c["alpha2Code"])
#         end


# Plan.create(name: "gift", days:7, price: 0)
# Plan.create(name: "1month", days:30, price: 12.20)
# Plan.create(name: "3month", days:90, price: 34.50)
# Plan.create(name: "6month", days:180, price: 65.80)
# Plan.create(name: "12month", days:536, price: 12.30)


# Admin.create(username: "admin", password: "password")


# 10.times do
#     Server.create!(
#         host: "grikvewhsona.ufasvpn.com",
#         premium: [true,false].sample,
#         country: Country.all.sample,
#         server_type: [:ikev, :ovpn].sample
#     )
# end
# 30.times do 
#     user = User.create(email: Faker::Internet.email, password: "password", user_type: "demo")
# end

# 30.times do 
#     user = User.create(email: Faker::Internet.email, password: "password", user_type: "registered")

#     6.times do
#         date = Date.today - (8..40).to_a.sample.months
#         plan = Plan.all.sample
#         account = Account.create!(
#             plan: plan,
#             user: user,
#             created_at: date,
#             valid_to: date + plan.days.days
#         )
#     end


#     20.times do
#         UserServer.create(user: user, server: Server.all.sample)
#     end

# end

require 'csv'    

CSV.foreach(Rails.root.join('db/worldcities.csv'), headers: true) do |row|  
    country = Country.where('lower(name) like ?', "%#{row[4].downcase}%").first
    next if country.nil?
    country.lat = row[2]
    country.lng = row[3]
    country.save
end
