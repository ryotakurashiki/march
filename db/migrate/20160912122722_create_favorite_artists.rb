class CreateFavoriteArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :favorite_artists do |t|
      t.integer :artist_id
      t.integer :user_id

      t.timestamps
    end
  end
end
