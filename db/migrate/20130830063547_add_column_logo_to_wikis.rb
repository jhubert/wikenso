class AddColumnLogoToWikis < ActiveRecord::Migration
  def change
    add_column :wikis, :logo, :string
  end
end
