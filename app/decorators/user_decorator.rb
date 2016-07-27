class UserDecorator < Draper::Decorator
  delegate_all

  def display_name
    if object.first_name.present? || object.last_name.present?
      "#{object.first_name} #{object.last_name}"
    else
      object.email
    end
  end

  def pending_request_for(section)
    object.requests.find_by(section: section, state: 'requested')
  end

  def pending_request_for?(section)
    pending_request_for(section).present?
  end

  # FIXME: Rollify uses polymophism which doesn't work properly
  # with STI on Section. Suggest using a collaborator model on sections instead
  def collaborator_on?(section)
    object.roles.exists?(resource_id: section)
  end

  def roles_for(section)
    roles = []
    Section.find_roles.pluck(:name).uniq.each do |role|
      roles += [role] if self.has_role?(role, section)
    end
    roles
  end
end
