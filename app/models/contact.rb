class Contact < ApplicationRecord
  belongs_to :company
  validates :name, :email, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
