class EmailReply < ApplicationRecord
  belongs_to :email
  belongs_to :contact
  belongs_to :user

  belongs_to :lead
end
