class Company < ApplicationRecord
  belongs_to :crawl_source
  has_many :contacts, dependent: :destroy
  validates :name, :industry, :website, presence: true
end
