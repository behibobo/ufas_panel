class CreateCountries < ActiveRecord::Migration[6.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :region, limit:100
      t.string :code, limit:20

      t.timestamps
    end
  end
end
