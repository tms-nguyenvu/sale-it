class Company < ApplicationRecord
  belongs_to :crawl_source

  validates :name, :industry, :website, presence: true
end
