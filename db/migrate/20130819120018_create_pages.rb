class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :text
      t.string :title
      t.integer :wiki_id
      t.integer :user_id

      t.timestamps
    end
  end
end
