class AddCreatorIdToConcert < ActiveRecord::Migration[5.0]
  def change
    add_column :concerts, :creator_id, :integer, after: :livefans_path
  end
end
