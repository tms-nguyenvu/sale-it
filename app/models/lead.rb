class Lead < ApplicationRecord
  acts_as_taggable_on :tags

  enum :status, {
    new_lead: 0,
    sent: 1,
    replied: 2,
    demo: 3,
    negotiate: 4,
    closed: 5
  }, default: :new_lead, prefix: true

  enum :priority, {
    low: 0,
    medium: 1,
    high: 2
  }, default: :medium, prefix: true

  enum :outcome, {
    pending: 0,
    won: 1,
    lost: 2
  }, default: :pending, prefix: true

  enum :suggested_action, {
    send_email: 0,
    call: 1,
    send_proposal: 2,
    follow_up: 3,
    wait: 4
  }, default: :follow_up, prefix: :suggested

  enum :last_interaction, {
    email: 0,
    call: 1,
    meeting: 2,
    proposal: 3,
    note: 4
  }, default: :email, prefix: :last

  belongs_to :contact
  belongs_to :company
  belongs_to :manager, class_name: "User", optional: true
  has_many :email_replies, dependent: :destroy
  has_many :emails, dependent: :nullify
end
