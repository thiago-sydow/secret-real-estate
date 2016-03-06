class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :property_type
      t.string :name
      t.integer :goal
      t.string :name
      t.text :description
      t.float :price
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
