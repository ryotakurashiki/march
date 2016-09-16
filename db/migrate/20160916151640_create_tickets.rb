class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.text :info
      t.integer :concert_id
      t.integer :medium_id
      t.string :medium_ticket_id
      t.string :ticket_path
      t.text :seat
      t.string :number_of_tickets
      t.boolean :selling_separately, default: false
      t.integer :price
      t.string :remaining_time
      t.boolean :extra_payment, defaul: false

      t.index [:medium_id, :medium_ticket_id], unique: true

      t.timestamps
    end
  end
end
