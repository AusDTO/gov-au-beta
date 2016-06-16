class RequestForm < Reform::Form
  property :section_id, type: Fixnum
  property :message
end