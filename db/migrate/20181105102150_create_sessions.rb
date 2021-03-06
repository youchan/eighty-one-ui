class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.string :guid, null: false
      t.string :account_guid
      t.string :session_id
      t.datetime :login_at
      t.datetime :expire_at
      t.boolean :login
    end
  end
end
