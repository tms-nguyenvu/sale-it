class AddEmailReplyToLeads < ActiveRecord::Migration[8.0]
  def change
    add_reference :leads, :email_reply, foreign_key: true
  end
end
