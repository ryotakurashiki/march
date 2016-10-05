class SetLimitToUserName < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :username, :string, :limit => 16
    change_column :users, :username_jp, :string, :limit => 21
  end
end
