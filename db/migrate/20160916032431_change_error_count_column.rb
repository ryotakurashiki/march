class ChangeErrorCountColumn < ActiveRecord::Migration[5.0]
  def change
    change_column :crawl_statuses, :error_count, :integer, default: 0
  end
end
