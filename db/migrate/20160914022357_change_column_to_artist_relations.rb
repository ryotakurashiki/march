class ChangeColumnToArtistRelations < ActiveRecord::Migration[5.0]
  def change
    change_column :artist_relations, :related_eplus_artist_id, :string
  end
end
