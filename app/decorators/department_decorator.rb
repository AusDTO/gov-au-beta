class DepartmentDecorator < Draper::Decorator
  delegate_all

  def prefix
    if name_parts.count > 1
      name_parts.first.strip
    end
  end

  def title
    name_parts.last
  end

  private

  def name_parts
    @name_parts ||= name.split(/^(Department of (?:the )?)/).reject(&:blank?)
  end
end