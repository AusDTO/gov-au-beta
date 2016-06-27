module ContentAnalysisHelper

  # FIXME: This should probably be in a service object so it can be tested properly
  def lint(data)
    url = url_of('linters')
    response = HTTParty.post(url, body: { content: data } )
    if response.code == 200
      return JSON.parse(response.body)
    else
      raise "#{response.code} error for url #{url}"
    end
  end

  private

  def url_of(method)
    Rails.application.config.content_analysis_base_url + "/api/#{method}"
  end

end
