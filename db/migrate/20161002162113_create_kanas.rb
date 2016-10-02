class CreateKanas < ActiveRecord::Migration[5.0]
  def change
    create_table :kanas do |t|
      t.integer :artist_id
      t.string :name

      t.timestamps

      t.index [:artist_id, :name], unique: true
    end
  end
end
