class AddErrorMessageToCrawlStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :crawl_statuses, :error_message, :text, after: :error_count
  end
end
