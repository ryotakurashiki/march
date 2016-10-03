class DropTableLivefanTest < ActiveRecord::Migration[5.0]
  def change
    drop_table :livefan_tests
  end
end
