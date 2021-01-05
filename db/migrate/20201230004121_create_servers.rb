class CreateServers < ActiveRecord::Migration[6.0]
  def change
    create_table :servers do |t|
      t.string :host
      t.string :api_key
      t.integer :server_type
      t.boolean :premium, default:false
      t.references :country, null: false, foreign_key: true
      t.timestamps
    end
  end
end
