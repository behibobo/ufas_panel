class ServerSerializer < ActiveModel::Serializer
  attributes :id, :name, :region,:ip, :country_id, :flag, :host, :port, :api_key, :server_type, :premium, :popularity

  belongs_to :country
  
  def region
    object.country.region
  end

  def flag
    "https://countryflags.io/#{object.country.code}/shiny/64.png"
  end

  def name
    object.country.name
  end

  def popularity
    object.popularity
  end
end
