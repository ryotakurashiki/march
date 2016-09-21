class AddLogoToMedium < ActiveRecord::Migration[5.0]
  def change
    add_column :media, :logo, :string, after: :en_name
  end
end
