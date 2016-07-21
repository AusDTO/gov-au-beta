class MinisterDecorator < Draper::Decorator
  delegate_all

  def prefix
    if name_parts.count > 1
      name_parts.first.strip
    end
  end

  def ministry_or_title
    name_parts.last
  end

  #TODO clean this up once requirements are clear
  def sort_order
    if ministry_or_title == 'Prime Minister'
      'AAAAA' # force first
    else
      ministry_or_title
    end
  end

  private

  def name_parts
    @name_parts ||= name.split(/^(Minister for (?:the )?)/).reject(&:blank?)
  end
end
