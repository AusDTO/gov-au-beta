class NewsArticleForm < NodeForm
  feature Reform::Form::MultiParameterAttributes
  property :release_date, multi_params: true
  validates :release_date, presence: true
end