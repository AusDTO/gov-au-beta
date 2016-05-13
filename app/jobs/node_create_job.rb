require 'httparty'
include TemplatesHelper

class NodeCreateJob < ApplicationJob
  queue_as :default

  def perform(nid, vid)
    url = Rails.application.config.authoring_base_url + "/api/node/#{nid}/#{vid}"
    response = HTTParty.get(url)
    if response["uuid"]
      node = Node.find_by(uuid: response["uuid"]) || Node.new
      node.name = response["title"]
      node.uuid = response["uuid"]
      template = response["field_template"]["und"][0]["value"]
      if TemplatesHelper.exists?(template)
        node.template = template
      else
        node.template = 'default'
      end
      node.section = Section.first

      if not node.content_block
        node.content_block = ContentBlock.new()
      end

      node.content_block.body = response["body"]["und"][0]["value"]
      node.content_block.unique_id = response["uuid"] + "_body"
      node.content_block.save()
      node.save()
    end

  end
end