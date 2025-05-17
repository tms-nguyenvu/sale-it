class AddLeadIdToEmails < ActiveRecord::Migration[8.0]
  def change
    add_column :emails, :lead_id, :bigint
    add_index :emails, :lead_id
    add_foreign_key :emails, :leads
  end
end
