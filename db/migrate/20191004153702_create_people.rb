class CreatePeople < ActiveRecord::Migration[4.2]
  def change
    create_table :people do |t|
      t.text :first_name
      t.text :last_name
      t.text :weapon
      t.text :species
      t.text :vehicle
      t.text :gender
      t.timestamps
    end
  end
end
