class Company < ApplicationRecord
  belongs_to :crawl_source
  has_many :contacts, dependent: :destroy
  has_many :jobs, dependent: :destroy
  validates :name, :industry, :website, presence: true
  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
