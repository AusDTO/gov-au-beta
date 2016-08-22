class InviteForm < Reform::Form
  property :email
  validates :email, :presence => true, :email => true
end
