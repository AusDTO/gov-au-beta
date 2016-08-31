module UsersHelper
  def sanitized_phone_number(user)
    "**** *** *#{user.phone_number[-2..-1]}"
  end


  def sanitized_unconfirmed_phone_number(user)
    "**** *** *#{user.unconfirmed_phone_number[-2..-1]}"
  end
end