include ContentAnalysisHelper

class ContentAnalysisValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    info = ContentAnalysisHelper.lint(value)
    record.errors.add(attribute, 'failed the content analysis check') unless info.empty?
  end

end