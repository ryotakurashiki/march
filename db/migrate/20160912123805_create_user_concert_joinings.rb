class CreateUserConcertJoinings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_concert_joinings do |t|
      t.integer :user_id
      t.integer :concert_id

      t.timestamps
    end
  end
end
