class CreateTemplateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :template_sections do |t|
      t.string :title
      t.text :content
      t.references :template_proposal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
