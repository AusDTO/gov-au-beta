class NodeForm < Reform::Form
  property :section_id, type: Fixnum
  property :parent_id, type: Fixnum
  property :name

  collection :content_blocks do
    property :body
    validates :body, content_analysis: true
  end

  def prepopulate!(options={})
    self.content_blocks = Array.new(model.num_content_blocks) do 
      ContentBlock.new
    end
  end

end 