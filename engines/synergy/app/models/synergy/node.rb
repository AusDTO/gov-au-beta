module Synergy
  class Node < ApplicationRecord
    acts_as_tree order: 'position ASC'

    # validates :slug, presence: true, uniqueness: true

    def to_s
      self.slug
    end

  end
end
