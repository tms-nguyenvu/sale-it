class RenameOutboundEmailsToEmails < ActiveRecord::Migration[8.0]
  def change
    rename_table :outbound_emails, :emails
  end
end
