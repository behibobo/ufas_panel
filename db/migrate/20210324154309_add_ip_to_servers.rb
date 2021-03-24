class AddIpToServers < ActiveRecord::Migration[6.0]
  def change
    add_column :servers, :ip, :string
  end
end
