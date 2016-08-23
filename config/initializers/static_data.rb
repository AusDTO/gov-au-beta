raw_data = YAML.load_file(Rails.root.join('config/static_data.yml'))

STATIC_DATA = {
  department_topics: raw_data['department_topics'].collect {|k, v|
    [k, OpenStruct.new({
      blurb: v['blurb'],
      topics: v['topics'].collect {|raw_topic|
        OpenStruct.new raw_topic
      }})]
  }.to_h
}
