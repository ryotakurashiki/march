class CreateFavoritePrefectures < ActiveRecord::Migration[5.0]
  def change
    create_table :favorite_prefectures do |t|
      t.integer :prefecture_id
      t.integer :user_id

      t.timestamps
    end
  end
end
