if Rails.env.development?
  Liquid.cache_classes = false
end
Liquid::Template.error_mode = :warn
Liquid::Template.register_filter(LinkFilter)
Liquid::Template.register_tag('image', ImageTag)