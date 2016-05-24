require 'httparty'
include TemplatesHelper

class NodeCreateJob < ApplicationJob
  queue_as :default

  rescue_from(Exception) do |e|
    Rollbar.error('Failed to publish node', e)
    raise e
  end

  def perform(nid, vid)
    url = Rails.application.config.authoring_base_url + "/api/node/#{nid}/#{vid}"
    logger.info "Loading #{url}"
    response = HTTParty.get(url)
    if response.code == 200
      logger.info "Loaded #{url}"
      logger.debug "JSON: #{response.body}"
      resp_obj = DrupalMapper.parse(JSON.parse(response.body))

      node = Node.find_by(uuid: resp_obj.uuid) || Node.new
      node.name = resp_obj.title
      node.uuid = resp_obj.uuid
      template = resp_obj.template
      if TemplatesHelper.exists?(template)
        node.template = template
      else
        node.template = 'default'
      end

      node.section = Section.find(resp_obj.section)

      if not node.content_block
        node.content_block = ContentBlock.new()
      end

      if resp_obj.parent_uuid
        if parent = Node.find_by(uuid: resp_obj.parent_uuid)
          node.parent = parent
        else
          raise "Loaded url #{url} but parent uuid not found: #{resp_obj.parent_uuid}"
        end

      end

      node.content_block.body = resp_obj.body
      node.content_block.unique_id = resp_obj.uuid + "_body"
      node.content_block.save()
      node.save()

    else
      raise "#{response.code} error for url #{url}"
    end

  end
end