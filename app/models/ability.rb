class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.super_admin?
      can :view, :statistics
      can :create, WelcomePage
    end
  end
end
