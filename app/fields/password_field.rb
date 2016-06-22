require "administrate/field/base"

class PasswordField < Administrate::Field::Base

  # From https://github.com/DisruptiveAngels/administrate-field-password/blob/master/lib/administrate/field/password.rb
  def self.searchable?
    false
  end

  def truncate
    "•" * 6
  end

end
