module TemplatesHelper

  def list
    YAML.load_file("#{Rails.root}/app/views/templates/conf.yaml")
  end

  def exists?(template)
    list.keys.include? template
  end
  
end