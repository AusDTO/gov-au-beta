=begin

Include this module to allow the included model to store multiple content fields
and provide easy methods (virtual attributes) to access the content.
Currently it's designed to serve the Node class, and thus assumes there's a
'content' attribute of type hstore, json or jsonb.

In the included class, to define a content field, use the content_attribute
method in the class definition, e.g.:

class_attribute :content_foo

You can then call my_node#content_foo on instances to get that bit of content
(and the mutator #content_foo= to set that bit of content).

To access all the content at once, use the #all_content method, which provides
a hash of key/value pairs (use the #update_content method to replace all content
at once).

Under the hood, Storext (which uses Virtus) is used for the virtual attribute;
only String content is currently supported.

=end

module Container
  extend ActiveSupport::Concern

  included do 
    include Storext.model

    class_attribute :content_attributes
    self.content_attributes = []

    def self.content_attribute(attribute_name)
      module_eval <<-EOS
        self.content_attributes += [:#{attribute_name}]
        store_attribute :content, :#{attribute_name}, String
      EOS
    end
  end

  def all_content
    content_attributes.collect { |attribute_name|
      [attribute_name.to_sym, send(attribute_name)]
    }.to_h
  end

  # n.b. If hash has missing keys, content will not be affected
  def apply_content(hash)
    if hash.keys.any? {|k| !content_attributes.include?(k) }
      raise "Unknown content attribute: #{k}"
    end

    hash.each do |k, v|
      send "#{k}=", v
    end
  end
end