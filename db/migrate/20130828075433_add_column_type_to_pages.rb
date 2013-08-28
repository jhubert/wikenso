class AddColumnTypeToPages < ActiveRecord::Migration
  def change
    add_column :pages, :type, :string, default: "ActivePage"
    ActiveRecord::Base.connection.execute("UPDATE pages SET type='ActivePage' WHERE type IS NULL")
  end
end
