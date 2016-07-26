class NewsArticleForm < NodeForm
  feature Reform::Form::MultiParameterAttributes
  property :section_ids
  property :release_date, multi_params: true
  validates :release_date, presence: true
  validates :summary, presence: true
end