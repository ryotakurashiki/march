class AddColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tutorial_finished, :boolean, fefault: false, after: :username
  end
end
