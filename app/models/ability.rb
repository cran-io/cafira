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
    when 'Architect'
      can :manage, [BlueprintFile, Infrastructure]
    when 'Designer'
      can :manage, [Catalog, CatalogImage]
    when 'Organizer'
      can :manage, Infrastructure
    end

  end
end
