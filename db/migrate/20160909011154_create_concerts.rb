class CreateConcerts < ActiveRecord::Migration[5.0]
  def change
    create_table :concerts do |t|
      t.string :title
      t.string :place
      t.integer :prefecture_id
      t.date :date
      t.integer :category
      t.string :eplus_id
      t.boolean :self_plan
      t.boolean :title_edited
      t.timestamps
    end
  end
end
