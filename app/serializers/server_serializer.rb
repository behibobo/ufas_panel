class ServerSerializer < ActiveModel::Serializer
  attributes :id, :host, :port, :api_key, :server_type, :premium
end
