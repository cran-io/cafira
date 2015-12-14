class Ability
  include CanCan::Ability

  def initialize(user)
    if user.type == 'AdminUser'
      can :manage, :all
    end
  end
end
