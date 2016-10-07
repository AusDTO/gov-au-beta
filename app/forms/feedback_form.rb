class FeedbackForm < Reform::Form
  property :url
  property :comment

  validates :comment, presence: true
end
