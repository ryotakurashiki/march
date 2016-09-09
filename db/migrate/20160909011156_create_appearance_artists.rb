class CreateAppearanceArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :appearance_artists do |t|
      t.integer  "attachable_id"
      t.string   "attachable_type", limit: 255
      t.integer :artist_id
      t.timestamps
    end
  end
end
