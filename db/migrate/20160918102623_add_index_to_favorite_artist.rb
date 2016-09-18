class AddIndexToFavoriteArtist < ActiveRecord::Migration[5.0]
  def change
    add_index :favorite_artists, [:user_id, :artist_id], :unique => true
    add_index :favorite_prefectures, [:user_id, :prefecture_id], :unique => true
  end
end
