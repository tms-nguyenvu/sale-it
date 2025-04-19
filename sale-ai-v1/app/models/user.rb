class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable


  # Custom email format validation
  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/


  # Validations
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :password_complexity, if: :password_required?


  # Auto assign default role
  after_create :assign_default_role

  # Associations to other models
  has_many :assigned_leads, class_name: 'Lead', foreign_key: 'assigned_to'
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assigned_to'
  has_many :created_proposals, class_name: 'Proposal', foreign_key: 'created_by'

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
        errors.add :password, 'phải có ít nhất một chữ cái thường.'
      end

      if !password.match?(/(?=.*[A-Z])/)
        errors.add :password, 'phải có ít nhất một chữ cái viết hoa.'
      end

      if !password.match?(/(?=.*\d)/)
        errors.add :password, 'phải có ít nhất một số.'
      end

      if password.length < 6
        errors.add :password, 'phải có ít nhất 6 ký tự.'
      end
    end

end
