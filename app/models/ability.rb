class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all
    end

    if user.id
      # TODO: Should all logged in users be able to view editorial pages?
      can :view, :editorial_page
      can :manage, Node, :section => {:id => Section.with_role(:author, user).pluck(:id)}, :state => :draft
      can :read, Node, :section => {:id => Section.with_role(:reviewer, user).pluck(:id)}, :state => :draft
    end

    # Everyone (signed in or not) can view published pages.
    can :read, Node, :state => :published
  end
end
