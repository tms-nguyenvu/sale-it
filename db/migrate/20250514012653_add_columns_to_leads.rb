class AddColumnsToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :project_name, :string
    add_column :leads, :start_date, :date
    add_column :leads, :end_date, :date
  end
end
