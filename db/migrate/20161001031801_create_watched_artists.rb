class CreateWatchedArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :watched_artists do |t|
      t.integer :appearance_artist_id
      t.integer :user_concert_joining_id
      t.boolean :watched
      t.timestamps

      t.index [:appearance_artist_id, :user_concert_joining_id], unique: true, name: "appearance_artist_user_unique"
    end
  end
end
