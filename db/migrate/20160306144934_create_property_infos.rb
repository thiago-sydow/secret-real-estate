class CreatePropertyInfos < ActiveRecord::Migration
  def change
    create_table :property_infos do |t|
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :car_spaces
      t.string :square_footage
      t.references :property, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
