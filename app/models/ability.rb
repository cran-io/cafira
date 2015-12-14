class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    case user.type
    when 'AdminUser'
      can :manage, :all
    when 'Expositor'
      can :manage, Expositor, :id => user.id 
      can :manage, [Catalog, Credential, AditionalService, Infrastructure], :expositor_id => user.id
    end
  end
end
