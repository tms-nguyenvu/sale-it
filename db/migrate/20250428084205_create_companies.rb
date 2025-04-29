class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :industry
      t.string :website
      t.references :crawl_source, null: false, foreign_key: true

      t.timestamps
    end
  end
end
