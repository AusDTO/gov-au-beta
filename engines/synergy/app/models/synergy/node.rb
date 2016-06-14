module Synergy
  class Node < ApplicationRecord
    acts_as_tree order: 'order_num ASC'

  end
end
