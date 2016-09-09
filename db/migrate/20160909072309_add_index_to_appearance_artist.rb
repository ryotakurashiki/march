class AddIndexToAppearanceArtist < ActiveRecord::Migration[5.0]
  def change
    add_index :appearance_artists, [:attachable_id, :attachable_type, :artist_id], :unique => true, :name => 'appearance_artist_unique'
  end
end
