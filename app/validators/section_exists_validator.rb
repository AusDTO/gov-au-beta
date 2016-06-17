class SectionExistsValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'section doesn\'t exist') if Section.find_by(id: value).nil?
  end

end