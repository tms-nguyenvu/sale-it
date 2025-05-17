class AddLeadToEmailReplies < ActiveRecord::Migration[8.0]
  def change
    add_reference :email_replies, :lead, foreign_key: true
  end
end
