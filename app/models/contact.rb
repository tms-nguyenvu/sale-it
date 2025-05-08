class Contact < ApplicationRecord
  belongs_to :company
  validates :name, :email, presence: true


  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
  scope :is_decision_maker, -> { where(is_decision_maker: true) }
end
