class AddCreatorIdToAppearanceArtist < ActiveRecord::Migration[5.0]
  def change
    add_column :appearance_artists, :creator_id, :integer, after: :not_decided
  end
end
