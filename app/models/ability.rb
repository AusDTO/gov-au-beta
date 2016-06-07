class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.is_admin?
      can :manage, :all
    end

    if user.is_author?
      can :view, :editorial_page
      can :read, Node, :state => "draft"
    end

    if user.is_reviewer?
      can :view, :editorial_page
      can :read, Node, :state => "draft"
    end

    #can :read, Node, :state => "published"
  end
end
