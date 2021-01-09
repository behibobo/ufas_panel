# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

uri = URI.parse("https://restcountries.eu/rest/v2/all")

        response = Net::HTTP.get_response(uri)
        hash = JSON.parse(response.body)
        Country.destroy_all
        hash.each do |c|
            Country.create(name: c["name"], region: c["region"], code: c["alpha2Code"])
        end
        
Plan.create(name: "gift", days:7, price: 0)
10.times do
    Server.create!(
        host: "grikvewhsona.ufasvpn.com",
        premium: [true,false].sample,
        country: Country.all.sample
    )
end