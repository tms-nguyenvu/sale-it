class AddColumnsToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :funding_round, :string
    add_column :companies, :employee_count, :string
    add_column :companies, :hiring_roles_count, :string
    add_column :companies, :potential_score, :integer
    add_column :companies, :note, :text
  end
end
