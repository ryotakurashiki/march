class AddIndexToMediumArtistRelation < ActiveRecord::Migration[5.0]
  def change
    add_index :medium_artist_relations, [:medium_id, :artist_id], :unique => true
  end
end
