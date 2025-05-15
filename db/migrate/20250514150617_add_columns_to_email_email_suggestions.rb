class AddColumnsToEmailEmailSuggestions < ActiveRecord::Migration[8.0]
  def change
    add_column :email_suggestions, :suggested_action, :string
    add_column :email_suggestions, :reasoning, :string
  end
end
