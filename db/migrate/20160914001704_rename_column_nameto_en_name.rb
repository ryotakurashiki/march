class RenameColumnNametoEnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :media, :name, :en_name
    add_column :media, :name, :string, after: :id
  end
end
