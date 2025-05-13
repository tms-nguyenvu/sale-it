class CreateEmailSuggestions < ActiveRecord::Migration[8.0]
  def change
    create_table :email_suggestions do |t|
      t.references :email, null: false, foreign_key: true
      t.jsonb :data

      t.timestamps
    end
  end
end
