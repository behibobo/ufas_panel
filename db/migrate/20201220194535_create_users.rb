class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :uuid
      t.string :referral_code
      t.boolean :online
      t.date :last_online, null: true
      t.references :referred_by, null: true, foreign_key: {to_table: :users}
      t.timestamps
    end
  end
end
