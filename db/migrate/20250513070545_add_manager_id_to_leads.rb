class AddManagerIdToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :manager_id, :integer
    add_foreign_key :leads, :users, column: :manager_id
    add_index :leads, :manager_id
  end
end
