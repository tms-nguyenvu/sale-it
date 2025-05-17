class TemplateProposal < ApplicationRecord
  has_many :template_sections, dependent: :destroy
  has_many :proposals, dependent: :nullify
  accepts_nested_attributes_for :template_sections, allow_destroy: true
end
