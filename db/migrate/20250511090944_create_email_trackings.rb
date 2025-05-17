class CreateEmailTrackings < ActiveRecord::Migration[8.0]
  def change
    create_table :email_trackings do |t|
      t.references :email, null: false, foreign_key: true
      t.datetime :clicked_at

      t.timestamps
    end
  end
end
