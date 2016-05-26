class ContentBlock < ApplicationRecord
  belongs_to :node, :dependent => :destroy
  validates :body, content_analysis: true
end
