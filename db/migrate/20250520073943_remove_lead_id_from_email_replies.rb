class RemoveLeadIdFromEmailReplies < ActiveRecord::Migration[8.0]
  def change
    remove_column :email_replies, :lead_id, :integer
  end
end
