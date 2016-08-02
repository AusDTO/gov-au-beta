class EmailDomainWhitelistValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'only *.gov.au email addresses permitted') if value !~ /\.gov\.au\z/
  end

end
