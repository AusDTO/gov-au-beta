module UsersHelper
  def sanitized_phone_number(user)
    "XXXX XXX X#{user.phone_number[-2..-1]}"
  end


  def sanitized_unconfirmed_phone_number(user)
    "XXXX XXX X#{user.unconfirmed_phone_number[-2..-1]}"
  end
end