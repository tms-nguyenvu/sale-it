class AddSuggestionsToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :suggestions, :jsonb
  end
end
