class AddUuidToAdmin < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :uuid, :string
  end
end
