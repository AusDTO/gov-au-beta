module SectionsHelper
  def hero_class(section)
    unless section.is_a? Topic
      return 'corporate'
    end

    ''
  end
end