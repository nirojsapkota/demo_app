class CreateAffiliations < ActiveRecord::Migration[4.2]
  def change
    create_table :affiliations do |t|
      t.text :name
      t.timestamps
      t.belongs_to :person
    end
  end
end
