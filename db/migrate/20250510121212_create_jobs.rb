class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :level
      t.string :location
      t.string :employment_type
      t.string :tech_stack
      t.date :posted_date
      t.string :application_url
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
