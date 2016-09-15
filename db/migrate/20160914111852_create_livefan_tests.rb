class CreateLivefanTests < ActiveRecord::Migration[5.0]
  def change
    create_table :livefan_tests do |t|
      t.string :livefans_artist_id
      t.string :result_text
      t.string :artist_name
      t.string :eplus_artist_id
      t.string :search_url

      t.timestamps
    end
  end
end
