class CreateAppearanceArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :appearance_artists do |t|
      t.integer :concert_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
