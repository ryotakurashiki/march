class CreateCrawlStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :crawl_statuses do |t|
      t.integer  :status
      t.integer  :error_count
      t.integer  :priority
      t.datetime :crawled_on
      t.integer  :medium_artist_relation_id, unique: true
      t.timestamps
    end
  end
end
