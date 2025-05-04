class Company < ApplicationRecord
  include PgSearch::Model
  belongs_to :crawl_source
  has_many :contacts, dependent: :destroy
  validates :name, :industry, :website, presence: true


  pg_search_scope :search_full_text,
    against: [ :name, :industry, :website ],
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english"
      }
    }
end
