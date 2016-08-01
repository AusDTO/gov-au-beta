class NewsArticleDecorator < NodeDecorator
  delegate_all

  def related_sections
    object.sections.reject do |related_section|
      related_section == object.section
    end
  end
end