class NewsArticleDecorator < NodeDecorator
  delegate_all

  def related_sections
    object.sections.reject do |related_section|
      related_section == object.section
    end
  end

  def publishers
    object.sections.select do |section|
      section.class != Topic
    end
  end

  def related_topics
    object.sections.select do |section|
      section.class == Topic
    end
  end
end