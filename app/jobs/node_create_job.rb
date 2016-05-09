require 'httparty'

class NodeCreateJob < ApplicationJob
  queue_as :default

  def perform(id)
    url = Rails.application.config.authoring_base_url + "/api/node/"+id
    response = HTTParty.get(url)
    if response["nid"]
      node = Node.find_by(name: response['title']) || Node.new
      node.name = response["title"]
      node.template = Template.first
      node.section = Section.first
      if not node.content_block
        node.content_block = ContentBlock.new()
      end
      node.content_block.body = response["body"]["und"][0]["value"]
      node.content_block.save()
      node.save()
    end
  end
end