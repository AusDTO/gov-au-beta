class DrupalMapper

  def initialize(json)

  end

  def fields
    {
        'title' => 'title',
        'uuid' => 'uuid',
        'body' => ['body', 'und', 0, 'value'],
        'section' => ['field_section', 'und', 0, 'value'],
        'template' => ['field_template', 'und', 0, 'value'],
    }
  end
end