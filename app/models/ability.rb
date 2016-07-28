class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all

      cannot :manage, Node do |node|
        node.section.cms_type != Section::COLLABORATE_CMS
      end

      cannot :create_in, Section do |section|
        section.cms_type != Section::COLLABORATE_CMS
      end
    end

    if user.id
      # TODO: Should all logged in users be able to view editorial pages?
      can :view, :editorial_page

      can :manage, Node do |node|
        user.has_role?(:author, node.section) &&
            node.section.cms_type == Section::COLLABORATE_CMS
      end

      can :show, Request do |request|
        user == request.user ||
            user.has_role?(:owner, request.section)
      end

      can :update, Request do |request|
        request.state == 'requested' &&
            user.has_role?(:owner, request.section) &&
            user != request.user
      end

      can :read, Node do |node|
        user.has_role?(:reviewer, node.section)
      end

      can :create_in, Section do |section|
        user.has_role?(:author, section) &&
            section.cms_type == Section::COLLABORATE_CMS
      end

      can :create, :news do
        # if author of any section
        user.roles.where(name: :author).count > 0
      end

      can :read, Section do |section|
        (
          user.has_role?(:author, section)   ||
          user.has_role?(:reviewer, section) ||
          user.has_role?(:owner, section)
        ) && section.cms_type == Section::COLLABORATE_CMS
      end

      can :review, Submission do |submission|
        submission.submitted? && submission.section.present? &&
          user.has_role?(:reviewer, submission.section)
      end

      can :review_in, Section do |section|
        user.has_role? :reviewer, section
      end
    end

    # Everyone (signed in or not) can view published pages.
    can :read_public, Node, :state => :published
  end
end
