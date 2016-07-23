class NewsArticleMetadataForm < Reform::Form
  feature Reform::Form::MultiParameterAttributes
  property :section_id
  property :section_ids
  property :release_date, multiparams: true

  property :options, form: OptionsForm
end