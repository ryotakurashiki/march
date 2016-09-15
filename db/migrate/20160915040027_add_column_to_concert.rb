class AddColumnToConcert < ActiveRecord::Migration[5.0]
  def change
    add_column :concerts, :livefans_path, :string, :after => :eplus_id
  end
end
