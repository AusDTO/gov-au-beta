class FeedbackForm < Reform::Form
  property :url
  property :email
  property :comment
  property :role
  property :organisation

  validates :email, :comment, presence: true
end
