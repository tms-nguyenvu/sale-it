class Contact < ApplicationRecord
  belongs_to :company
  validates :name, :email, presence: true
  has_many :emails, dependent: :destroy

  def self.ransackable_associations(auth_object = nil)
    [ "emails" ]
  end
  def self.ransackable_attributes(auth_object = nil)
    [ "name", "email" ]
  end
  scope :is_decision_maker, -> { where(is_decision_maker: true) }
end
