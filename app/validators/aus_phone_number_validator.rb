class AusPhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value != nil && value !~ /\A04[0-9]{8}\z/
      record.errors.add(attribute, "is not a valid Australian mobile phone-number")
    end
  end
end