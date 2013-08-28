class RemoveColumnTypeFromPages < ActiveRecord::Migration
  def change
    remove_column :pages, :type
  end
end
