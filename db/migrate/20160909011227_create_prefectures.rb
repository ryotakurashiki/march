class CreatePrefectures < ActiveRecord::Migration[5.0]
  def change
    create_table :prefectures do |t|
      t.string :name
      t.string :area

      t.timestamps
    end
  end
end
