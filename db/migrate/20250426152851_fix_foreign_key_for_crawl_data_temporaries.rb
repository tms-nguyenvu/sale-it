class FixForeignKeyForCrawlDataTemporaries < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :crawl_data_temporaries, :crawl_sources

    add_foreign_key :crawl_data_temporaries, :crawl_sources, on_delete: :cascade
  end
end
