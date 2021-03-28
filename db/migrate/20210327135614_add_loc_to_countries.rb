class AddLocToCountries < ActiveRecord::Migration[6.0]
  def change
    add_column :countries, :lng, :string
    add_column :countries, :lat, :string
  end
end
