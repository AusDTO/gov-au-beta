class NewsArticleForm < NodeForm
  feature Reform::Form::MultiParameterAttributes
  property :name, presence: true
  property :short_summary, presence: true
  property :summary, presence: true
  property :section_id
  property :section_ids
  property :release_date, multi_params: true
  validates :release_date, presence: true
  validates :name, presence: true
  validates :section_id, presence: true
  validates :short_summary, presence: true
  validates :summary, presence: true
end