class CreateMediumArtistRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :medium_artist_relations do |t|
      t.integer :medium_id
      t.integer :artist_id
      t.integer :medium_artist_id

      t.timestamps
    end
  end
end
