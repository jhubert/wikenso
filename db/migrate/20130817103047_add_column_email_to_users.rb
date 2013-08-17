class AddColumnEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_index :users, [:email, :wiki_id], unique: true
  end
end
