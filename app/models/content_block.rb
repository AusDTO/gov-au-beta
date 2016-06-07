class ContentBlock < ApplicationRecord
  belongs_to :node, :dependent => :destroy
end
