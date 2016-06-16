class Request < ApplicationRecord
  belongs_to :user
  has_one :section
  has_one :owner, class_name: 'User'

  STATES = %w(requested approved rejected)

  enumerize :state, in: STATES, scope: true
end