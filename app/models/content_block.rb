class ContentBlock 
  include Virtus.model
  attribute :body, String

  def persisted?
    false
  end
end