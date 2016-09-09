class AddIndexToPrefecture < ActiveRecord::Migration[5.0]
  def change
    add_index :prefectures, :name, unique: true
  end
end
