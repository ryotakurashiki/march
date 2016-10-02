class AddKanaDoneToArtist < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :kana_done, :boolean, default: false
  end
end
