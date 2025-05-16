class TemplateProposal < ApplicationRecord
  has_many :template_sections, dependent: :destroy
  accepts_nested_attributes_for :template_sections, allow_destroy: true
end
