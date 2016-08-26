class UserForm < Reform::Form
  include Reform::Form::ActiveRecord
  property :email
  property :first_name
  property :last_name

  validates :email, presence: true, email_domain_whitelist: true
  validates_uniqueness_of :email
end
