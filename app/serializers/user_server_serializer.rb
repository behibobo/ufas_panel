class UserServerSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :server
end
