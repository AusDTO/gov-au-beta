require 'httparty'
include TemplatesHelper

class NodeCreateJob < ApplicationJob
  queue_as :default

  def perform(nid, vid)
    url = Rails.application.config.authoring_base_url + "/api/node/#{nid}/#{vid}"
    response = HTTParty.get(url)
    if response.code == 200
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
      node.section = Section.first

      if not node.content_block
        node.content_block = ContentBlock.new()
      end

      node.content_block.body = resp_obj.body
      node.content_block.unique_id = resp_obj.uuid + "_body"
      node.content_block.save()
      node.save()

    elsif response.code == 404
      # TODO: something interesting here
    end

  end
end