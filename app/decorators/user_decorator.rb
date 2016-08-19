class UserDecorator < Draper::Decorator
  delegate_all

  def display_name
    if object.first_name.present? || object.last_name.present?
      "#{object.first_name} #{object.last_name}"
    else
      object.email
    end
  end


  # TODO: this belongs on User. It's not a presentation concern.
  def roles_for(section)
    roles = []
    Section.find_roles.pluck(:name).uniq.each do |role|
      roles += [role] if self.has_role?(role, section)
    end
    roles
  end
end
