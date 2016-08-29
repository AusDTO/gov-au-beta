class FeedbackForm < Reform::Form
  property :url
  property :email
  property :comment
  property :role
  property :organisation

  validates :email, :comment, :role, :organisation, presence: true
end
