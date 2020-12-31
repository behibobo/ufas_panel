class AddPortToServers < ActiveRecord::Migration[6.0]
  def change
    add_column :servers, :port, :integer
  end
end
