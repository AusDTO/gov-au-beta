hashes = YAML.load_file(Rails.root.join('config/categories.yml'))
STATIC_CATEGORIES = hashes.collect do |hash|
  OpenStruct.new hash
end
