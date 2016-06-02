class PreviewDecorator < Draper::Decorator
  delegate_all

  def section
    Section.new object.section
  end

  def content_blocks
    object.content_blocks.collect do |hash|
      ContentBlock.new hash
    end
  end

  #TODO Get rid of this syntactic sugar once we've refactored Node
  #     to have many ContentBlocks (right now it has one)
  def content_block
    content_blocks.first
  end
end
