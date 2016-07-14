class SectionHomeForm < Reform::Form
  property :name

  #TODO figure out a way to combine these to DRY up future content block declarations
  property :content_body
end
