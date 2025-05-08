class CreateEmails < ActiveRecord::Migration[8.0]
  def change
    create_table :emails do |t|
      t.references :contact, null: false, foreign_key: true
      t.string :subject
      t.text :content
      t.integer :email_type
      t.string :tone
      t.timestamp :sent_at
      t.integer :status
      t.timestamp :opened_at
      t.timestamp :replied_at
      t.timestamp :clicked_at

      t.timestamps
    end
  end
end
