class CreateCrawlDataTemporaries < ActiveRecord::Migration[8.0]
  def change
    create_table :crawl_data_temporaries do |t|
      t.jsonb :data
      t.integer :data_status

      t.timestamps
    end
  end
end
