class RootNode < Node
  validates_absence_of :parent, :slug, :section

  def self.news
    NewsArticle.published.limit(8).all
  end

  def self.ministers
    Minister.all
  end

  def self.departments
    Department.all
  end

  def self.agencies
    Agency.all
  end
end
