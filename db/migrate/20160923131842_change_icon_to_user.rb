class ChangeIconToUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :icon, :string, default: "default_icon.png"
  end
end
