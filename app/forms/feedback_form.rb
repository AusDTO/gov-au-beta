class FeedbackForm < Reform::Form
  property :url
  property :comment
  # property :email
  # property :role
  # property :organisation
  #
  # validates :email, :comment, :role, :organisation, presence: true
  # validates :email, :email => true
end
