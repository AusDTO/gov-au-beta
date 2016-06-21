class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def roles_for(section)
    roles = []
    Section.find_roles.pluck(:name).uniq.each do |role|
      roles += [role] if self.has_role?(role, section)
    end
    roles
  end
end