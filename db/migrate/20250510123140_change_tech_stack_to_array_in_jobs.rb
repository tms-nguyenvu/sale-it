class ChangeTechStackToArrayInJobs < ActiveRecord::Migration[8.0]
  def change
    change_column :jobs, :tech_stack, :string, array: true, default: []
  end
end
