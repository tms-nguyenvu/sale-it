class AddCrawlSourceIdToCrawlDataTemporaries < ActiveRecord::Migration[8.0]
  def change
    add_reference :crawl_data_temporaries, :crawl_source, null: false, foreign_key: true
  end
end
