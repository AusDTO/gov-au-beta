class NodeForm < Reform::Form
  property :section_id, type: Fixnum
  property :parent_id, type: Fixnum
  property :name

  #TODO figure out a way to combine these to DRY up future content block declarations
  property :content_body

  property :options, form: OptionsForm
  #validates :content_body, content_analysis: true #FIXME: restore once we have feedback and/or ability to ignore
end
