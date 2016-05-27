module AuthoringHelper

  def get_node(nid, vid)
    url = Rails.application.config.authoring_base_url + "/api/node/#{nid}/#{vid}"
    Rails.logger.info "Loading #{url}"
    response = HTTParty.get(url)
    if response.code == 200
      Rails.logger.info "Loaded #{url}"
      Rails.logger.debug "JSON: #{response.body}"
      return DrupalMapper.parse(JSON.parse(response.body))
    else
      raise "#{response.code} error for url #{url}"
    end
  end

  def publish_result(nid, vid, success)
    url = Rails.application.config.authoring_base_url + "/api/node/result/#{nid}/#{vid}"
    Rails.logger.info "Posting to #{url}, success status #{success}"
    response = HTTParty.post(url, body: { success: success })
    if response.code != 200
      raise "#{response.code} error for url #{url}"
    end
    Rails.logger.info "JSON: #{response.body}"
  end

end
