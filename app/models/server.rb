class Server < ApplicationRecord
    belongs_to :country
    enum server_type: [:ikev, :ovpn]
end
