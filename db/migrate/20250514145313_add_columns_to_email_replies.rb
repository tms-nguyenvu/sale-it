class AddColumnsToEmailReplies < ActiveRecord::Migration[8.0]
  def change
    add_column :email_replies, :suggested_action, :string
    add_column :email_replies, :reasoning, :string
  end
end
