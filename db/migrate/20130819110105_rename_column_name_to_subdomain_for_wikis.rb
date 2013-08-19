class RenameColumnNameToSubdomainForWikis < ActiveRecord::Migration
  def change
    rename_column :wikis, :name, :subdomain
  end
end
