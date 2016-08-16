Rails.application.configure do

  def check_format(url, name)
    raise "#{name} cannot be empty" if url.blank?
    raise "#{name} must start with http(s)" unless url.starts_with?('http')
    raise "#{name} must not have a trailing slash" if url.ends_with?('/')
    url
  end

  if !Rails.env.static?
    config.content_analysis_base_url = check_format(ENV['CONTENT_ANALYSIS_BASE_URL'], 'content analysis base url')
  else
    config.content_analysis_base_url = "https://dummy"
  end

end
