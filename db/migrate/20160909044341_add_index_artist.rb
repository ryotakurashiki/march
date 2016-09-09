class AddIndexArtist < ActiveRecord::Migration[5.0]
  def change
    add_index :artists, :name, unique: true
  end
end
