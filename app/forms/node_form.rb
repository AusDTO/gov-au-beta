class NodeForm < Reform::Form
  property :section_id, type: Fixnum
  property :parent_id, type: Fixnum
  property :name
  property :short_summary
  property :summary

  #TODO figure out a way to combine these to DRY up future content block declarations
  property :content_body

  property :options, form: OptionsForm
  validates :name, presence: true
  validates :short_summary, presence: true
end
