class NewsArticle < Node
  has_many :news_distributions
  has_many :sections, through: :news_distributions, source: :distribution,
           source_type: 'Section'

  alias_method :publisher, :section

  store_attribute :data, :release_date, Date

  validates_presence_of :section, :parent
  validates :parent, ancestry_depth: { minimum: 2 }

  scope :published, -> { where state: 'published' }
end
