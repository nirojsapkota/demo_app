class CreateLocations < ActiveRecord::Migration[4.2]
  def change
    create_table :locations do |t|
      t.text :name
      t.timestamps
      t.belongs_to :person
    end
  end
end
