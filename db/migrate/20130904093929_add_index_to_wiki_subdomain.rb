class AddIndexToWikiSubdomain < ActiveRecord::Migration
  def change
    add_index :wikis, :subdomain, unique: true
  end
end
