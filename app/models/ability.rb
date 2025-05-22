class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :sale_support
      # Sales support can only view and manage leads assigned to them.
      can :read, Lead, manager_id: user.id
      can :update, Lead, manager_id: user.id

      # Can create and manage emails for assigned leads
      can :create, Email
      can :manage, Email, user_id: user.id

      # Can create and manage proposals for assigned leads
      can :create, Proposal
      can :manage, Proposal, user_id: user.id

      # View basic information
      can :read, Contact
      can :read, Company
      can :read, User, id: user.id
      can :update, User, id: user.id
    else
      cannot :manage, :all
    end
  end
end
