class AddScheduledToCrawlSources < ActiveRecord::Migration[8.0]
  def change
    add_column :crawl_sources, :scheduled, :boolean, default: false
  end
end
