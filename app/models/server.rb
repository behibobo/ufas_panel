class Server < ApplicationRecord
    enum server_type: [:ikev, :ovpn]
end
