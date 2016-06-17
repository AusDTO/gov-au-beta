module Synergy
  class Node < ApplicationRecord
    extend ActsAsTree::TreeView
    extend ActsAsTree::TreeWalker

    acts_as_tree order: 'position ASC'

    def parents
      @parents ||= collect_parents
    end

    def path
      parents.reverse.collect(&:slug).join('/')
    end

    def name
      slug.blank? ? 'Home' : slug 
    end
    # validates :slug, presence: true, uniqueness: true

    # def to_s
    #   self.slug
    # end

    private
    def collect_parents
      arr = [self]

      while parent = arr.last.parent
        arr << parent
      end

      arr
    end
  end
end
