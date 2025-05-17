class CreateProposals < ActiveRecord::Migration[8.0]
  def change
    create_table :proposals do |t|
      t.text :requirement
      t.string :title
      t.references :template_proposal, null: false, foreign_key: true
      t.string :pdf_ur
      t.references :lead, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
