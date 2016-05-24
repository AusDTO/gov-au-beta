class DrupalMapper

  def self.parse(json)
    json_map = fields.inject({}) do |agg, (k, v)|
      agg[k] = v.inject(json) do |iterator, node|
        iterator.fetch(node)
      end
      agg
    end

    Hashie::Mash.new json_map

  end

private
  def self.fields
    {
        'title' => ['title'],
        'uuid' => ['uuid'],
        'body' => ['body', 'und', 0, 'value'],
        'section' => ['field_section', 'und', 0, 'value'],
        'template' => ['field_template', 'und', 0, 'value'],
        'parent_uuid' => ['field_parent', 'und', 0, 'target_uuid'],
    }
  end
end