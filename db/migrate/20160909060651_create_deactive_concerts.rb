class CreateDeactiveConcerts < ActiveRecord::Migration[5.0]
  def change
    create_table :deactive_concerts do |t|
      t.string :title
      t.string :place
      t.integer :prefecture_id
      t.date :date
      t.string :category
      t.string :eplus_id
      t.boolean :self_planed
      t.string :date_text
      t.boolean :active

      t.timestamps
    end

    add_index :deactive_concerts, [:title, :place, :date_text]
  end
end
