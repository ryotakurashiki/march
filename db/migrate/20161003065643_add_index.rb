class AddIndex < ActiveRecord::Migration[5.0]
  def change
    #remove_index :medium_artist_relations, ["medium_id", "medium_artist_id"]
    add_index :medium_artist_relations, ["medium_id", "artist_id", "medium_artist_id"], unique: true, name: "artist_relations_uniq"
  end
end
