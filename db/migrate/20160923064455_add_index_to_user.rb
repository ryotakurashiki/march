class AddIndexToUser < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :username, unique: true
    change_column :users, :username, :string, null: false, default: ""
  end
end
