class ChangeMediumArtistRelatoin < ActiveRecord::Migration[5.0]
  def change
  	remove_column :medium_artist_relations, :medium_artist_id
    add_column :medium_artist_relations, :medium_artist_id, :string, :after => :artist_id

    remove_index :medium_artist_relations, [:medium_id, :artist_id]
    add_index :medium_artist_relations, [:medium_id, :medium_artist_id]
  end
end
