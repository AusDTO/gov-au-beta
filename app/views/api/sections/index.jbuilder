
json.array! @sections do |section|
  json.id section.id
  json.name section.name
  json.slug section.slug
end