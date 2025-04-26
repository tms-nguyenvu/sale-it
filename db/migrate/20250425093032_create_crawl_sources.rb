class CreateCrawlSources < ActiveRecord::Migration[8.0]
  def change
    create_table :crawl_sources do |t|
      t.string :source_url
      t.integer :source_type
      t.text :description
      t.integer :status
      t.integer :approval_status

      t.timestamps
    end
  end
end
