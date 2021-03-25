class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :account, :referred_by

  has_many :devices
  
  def account
    ActiveModelSerializers::SerializableResource.new(object.current_account)
  end

  def referred_by
    object.referred_by unless object.referred_by.nil?
  end

end
