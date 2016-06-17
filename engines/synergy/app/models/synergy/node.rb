module Synergy
  class Node < ApplicationRecord
    extend ActsAsTree::TreeView
    extend ActsAsTree::TreeWalker

    acts_as_tree order: 'position ASC'

    before_save :set_path!

    def name
      slug.blank? ? 'Home' : slug 
    end

    private

    def set_path!
      self.path = '/' + self.self_and_ancestors.map(&:slug).reverse.join('/')
    end
  end
end
