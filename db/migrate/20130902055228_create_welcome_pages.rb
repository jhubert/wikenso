class CreateWelcomePages < ActiveRecord::Migration
  def change
    create_table :welcome_pages do |t|
      t.text :text
      t.string :title

      t.timestamps
    end
  end
end
