class NewsArticleForm < NodeForm
  feature Reform::Form::MultiParameterAttributes
  property :short_summary, presence: true
  property :summary, presence: true
  property :section_ids
  property :release_date, multi_params: true
  validates :release_date, presence: true
  validates :short_summary, presence: true
  validates :summary, presence: true
end