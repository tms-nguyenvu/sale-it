class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Custom email format validation
  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/

  # Validations
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validate :password_complexity, if: :password_required?

  # Auto assign default role
  after_create :assign_default_role

  # Associations to other models
  has_many :assigned_leads, class_name: "Lead", foreign_key: "assigned_to"
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigned_to"
  has_many :created_proposals, class_name: "Proposal", foreign_key: "created_by"

  private

    def assign_default_role
      self.add_role(:sale_support) if self.roles.blank?
    end

    def password_required?
      new_record? || !password.nil?
    end

    def password_complexity
      return if password.blank?

      if !password.match?(/(?=.*[a-z])/)
        errors.add :password, "must include at least one lowercase letter."
      end

      if !password.match?(/(?=.*[A-Z])/)
        errors.add :password, "must include at least one uppercase letter."
      end

      if !password.match?(/(?=.*\d)/)
        errors.add :password, "must include at least one number."
      end

      if !password.match?(/(?=.*[\W])/)
        errors.add :password, "must include at least one special character."
      end

      if password.length < 6
        errors.add :password, "must be at least 6 characters long."
      end
    end
end
