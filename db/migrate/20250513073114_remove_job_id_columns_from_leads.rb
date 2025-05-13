class RemoveJobIdColumnsFromLeads < ActiveRecord::Migration[8.0]
  def change
    remove_column :leads, :job_id, :bigint
  end
end
