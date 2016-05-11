@templates.each do |template, details|
  json.set! template do
    json.name details['name']
    json.image details['image']
  end
end