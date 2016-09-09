class AddIndexToConcert < ActiveRecord::Migration[5.0]
  def change
    add_index :concerts, [:title, :place, :date], :unique => true
  end
end
