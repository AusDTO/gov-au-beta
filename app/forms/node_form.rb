class NodeForm < Reform::Form
  property :section_id, type: Fixnum
  property :parent_id, type: Fixnum
  property :name

  property :content_block do
    property :body
    validates :body, content_analysis: true
  end

end