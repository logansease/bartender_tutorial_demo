class AddBackgroundToBartenders < ActiveRecord::Migration
  def change
    add_column :bartenders, :background, :string
  end
end
