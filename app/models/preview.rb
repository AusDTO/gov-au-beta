class Preview < ApplicationRecord

  store_accessor :body, :section, :template, :content_blocks, :name

  validates_presence_of :token, :section, :template, :content_blocks
  validates_uniqueness_of :token

  validate :fully_populated

  private

  def fully_populated
    unless section && section['name'].present?
      errors.add :section, 'Section must have a name'
    end

    if content_blocks.present?
      content_blocks.each do |content_block|
        unless content_block['body'].present?
          errors.add :content_blocks, 'Every content block must have a body'
        end
      end
    end
  end

end
