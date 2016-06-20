class Request < ApplicationRecord
  extend Enumerize
  belongs_to :user
  belongs_to :section
  belongs_to :approver, class_name: 'User'

  STATES = %w(requested approved rejected)

  enumerize :state, in: STATES, scope: true
end