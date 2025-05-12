class RemoveTrackingColumnsFromEmails < ActiveRecord::Migration[8.0]
  def change
    remove_column :emails, :opened_at, :datetime
    remove_column :emails, :clicked_at, :datetime
  end
end
