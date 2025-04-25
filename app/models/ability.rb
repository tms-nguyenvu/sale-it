class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :sale_support
      can :read, [ Company, Contact ]
      can :manage, [ Lead, Task, Email, Proposal ], assigned_to: user.id
      can :create, [ Lead, Task, Email, Proposal ]
      can :read, User, id: user.id
      can :update, User, id: user.id
    else
      cannot :manage, :all
    end
  end
end
