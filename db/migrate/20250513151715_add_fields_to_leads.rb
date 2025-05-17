class AddFieldsToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :priority, :integer
    add_column :leads, :outcome, :integer
    add_column :leads, :suggested_action, :integer
    add_column :leads, :last_interaction, :integer
  end
end
