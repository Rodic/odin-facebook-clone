class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.text :about_me
      t.string :gender
      t.integer :age
      t.string :city
      t.string :country
      t.string :school
      t.string :work
      t.string :website

      t.timestamps
    end
    add_index :profiles, :user_id
  end
end
