class AddColumnToDeactiveConcert < ActiveRecord::Migration[5.0]
  def change
    add_column :deactive_concerts, :eplus_id_edited, :boolean, default: false, :after => :active
  end
end
