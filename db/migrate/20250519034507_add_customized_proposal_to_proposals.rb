class AddCustomizedProposalToProposals < ActiveRecord::Migration[8.0]
  def change
    add_column :proposals, :customized_proposal, :jsonb
  end
end
