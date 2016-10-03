class AddIndexToUserConcertJoining < ActiveRecord::Migration[5.0]
  def change
    add_index :user_concert_joinings, [:user_id, :concert_id], unique: true
  end
end
