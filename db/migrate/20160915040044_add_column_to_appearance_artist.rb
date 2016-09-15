class AddColumnToAppearanceArtist < ActiveRecord::Migration[5.0]
  def change
    add_column :appearance_artists, :setlist_path, :string, :after => :artist_id
    add_column :appearance_artists, :not_decided, :boolean, default: false, :after => :setlist_path
  end
end
