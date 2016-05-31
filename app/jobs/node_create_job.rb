require 'httparty'
include TemplatesHelper
include AuthoringHelper

class NodeCreateJob < ApplicationJob
  queue_as :default

  rescue_from(Exception) do |e|
    Rollbar.error('Failed to publish node', e)
    raise e
  end

  def perform (nid, vid)
    resp_obj = AuthoringHelper.get_node(nid, vid)
    Node.transaction do
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

      unless node.content_block
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
      node.content_block.save!()
      node.save!()
    end
  rescue Exception => e
    AuthoringHelper.publish_result(nid, vid, false)
    raise e
  else
    AuthoringHelper.publish_result(nid, vid, true)
  end

end