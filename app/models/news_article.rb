class NewsArticle < Node
  store_attribute :data, :release_date, Date

  validates_presence_of :section, :parent
  validates :parent, ancestry_depth: { minimum: 2 }
end
