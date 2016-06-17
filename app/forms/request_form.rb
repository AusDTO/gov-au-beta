class RequestForm < Reform::Form
  property :section_id, type: Fixnum
  property :message

  validates :section_id, presence: true
end