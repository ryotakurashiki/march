class AddColumnToArtist < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :creator_id, :integer, after: :category
    add_column :artists, :admin_denied, :boolean, default: false, after: :creator_id
  end
end
