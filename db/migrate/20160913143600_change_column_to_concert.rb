class ChangeColumnToConcert < ActiveRecord::Migration[5.0]
  def change
    change_column :concerts, :title_edited, :boolean, default: false
    change_column :concerts, :self_planed, :boolean, default: false

    change_column :deactive_concerts, :self_planed, :boolean, default: false
    change_column :deactive_concerts, :active, :boolean, default: false
  end
end
