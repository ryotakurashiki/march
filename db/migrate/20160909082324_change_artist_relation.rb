class ChangeArtistRelation < ActiveRecord::Migration[5.0]
  def change
    add_column :artist_relations, :related_eplus_artist_id, :integer
    add_index :artist_relations, [:artist_id, :related_eplus_artist_id], :unique => true
  end
end
