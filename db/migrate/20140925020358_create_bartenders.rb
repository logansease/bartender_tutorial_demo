class CreateBartenders < ActiveRecord::Migration
  def change
    create_table :bartenders do |t|
      t.string :bar
      t.integer :user_id
      t.boolean :is_working

      t.timestamps
    end
  end
end
