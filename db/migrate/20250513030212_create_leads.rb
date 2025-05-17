class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.references :contact, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.integer :status
      t.text :note

      t.timestamps
    end
  end
end
