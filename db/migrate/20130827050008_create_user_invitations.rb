class CreateUserInvitations < ActiveRecord::Migration
  def change
    create_table :user_invitations do |t|
      t.string :code
      t.references :user, index: true

      t.timestamps
    end
  end
end
