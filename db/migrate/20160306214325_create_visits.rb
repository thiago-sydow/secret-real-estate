class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.time  :visit_time
      t.references :visitable, polymorphic: true, index: true
      
      t.timestamps null: false
    end

    add_index :visits, :visit_time
  end
end
