class DrupalMapper

  def self.parse(json)
    json_map = fields.inject({}) do |agg, (attribute, info)|
      agg[attribute] = info[:path].inject(json) do |iterator, node|
        begin
          iterator.fetch(node)
        rescue KeyError, TypeError => e
          if info[:required]
            raise "Missing required field #{attribute}"
          else
            break
          end
        end
      end
      agg
    end

    Hashie::Mash.new json_map

  end

private
  def self.fields
    {
        'title' => { path: ['title'], required: true },
        'uuid' => { path: ['uuid'], required: true },
        'body' => { path: ['body', 'und', 0, 'value'], required: true },
        'section' => { path: ['field_section', 'und', 0, 'value'], required: true },
        'template' => { path: ['field_template', 'und', 0, 'value'], required: true },
        'parent_uuid' => { path: ['field_parent', 'und', 0, 'target_uuid'], required: false },
    }
  end
end