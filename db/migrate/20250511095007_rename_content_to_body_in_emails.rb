class RenameContentToBodyInEmails < ActiveRecord::Migration[8.0]
  def change
    rename_column :emails, :content, :body
  end
end
