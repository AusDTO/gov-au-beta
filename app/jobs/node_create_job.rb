require 'httparty'
include TemplatesHelper

class NodeCreateJob < ApplicationJob
  queue_as :default

  def perform(nid, vid)
    url = Rails.application.config.authoring_base_url + "/api/node/#{nid}/#{vid}"
    logger.info "Loading #{url}"
    response = HTTParty.get(url)
    if response.code == 200
      logger.info "Loaded #{response.body}"
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

      node.section = Section.find(
          response['field_section']['und'][0]['value']
      )

      if not node.content_block
        node.content_block = ContentBlock.new()
      end

      if resp_obj.parent_uuid
        if parent = Node.find_by(uuid: resp_obj.parent_uuid)
          node.parent = parent
        else
          logger.error "Parent uuid not found: #{resp_obj.parent_uuid}"
        end

      end

      node.content_block.body = resp_obj.body
      node.content_block.unique_id = resp_obj.uuid + "_body"
      node.content_block.save()
      node.save()

    elsif response.code == 404
      logger.error "404 error for url #{url}"
      # TODO: something interesting here
    end

  end
end