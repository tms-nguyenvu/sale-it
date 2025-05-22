class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :assigned_to_id
      t.integer :assigned_by_id
      t.datetime :due_date
      t.integer :status

      t.timestamps
    end
  end
end
