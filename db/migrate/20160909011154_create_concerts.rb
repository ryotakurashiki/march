class CreateConcerts < ActiveRecord::Migration[5.0]
  def change
    create_table :concerts do |t|
      t.text :title
      t.string :place
      t.integer :prefecture_id
      t.date :date
      t.integer :category
      t.integer :eplus_id

      t.timestamps
    end
  end
end
