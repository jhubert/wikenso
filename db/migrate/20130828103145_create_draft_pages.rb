class CreateDraftPages < ActiveRecord::Migration
  def change
    create_table :draft_pages do |t|
      t.string :title
      t.text :text
      t.references :wiki, index: true
      t.references :user, index: true
      t.references :page, index: true

      t.timestamps
    end
  end
end
