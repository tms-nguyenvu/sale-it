class CreateEmailReplies < ActiveRecord::Migration[8.0]
  def change
    create_table :email_replies do |t|
      t.references :email, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body
      t.datetime :received_at

      t.timestamps
    end
  end
end
