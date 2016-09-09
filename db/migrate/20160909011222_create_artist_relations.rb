class CreateArtistRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :artist_relations do |t|
      t.integer :artist_id
      t.integer :related_artist_id

      t.timestamps
    end
  end
end
