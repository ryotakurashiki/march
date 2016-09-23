class ChangeUserTable < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :username, :string, null: false
    add_column :users, :username_jp, :string, after: :username, default: "なまえ"
    add_column :users, :icon, :string, after: :username_jp
  end
end
