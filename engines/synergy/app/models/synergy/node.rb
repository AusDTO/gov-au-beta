module Synergy
  class Node < ApplicationRecord
    acts_as_tree order: 'position ASC'
  end
end
