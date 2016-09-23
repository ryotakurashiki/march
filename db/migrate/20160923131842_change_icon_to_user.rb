class ChangeIconToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :icon_tw, :string, after: :icon
  end
end
