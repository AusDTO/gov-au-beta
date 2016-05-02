module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug
  end

  def generate_slug
    if name_changed? 
      self.slug = name.try :parameterize
    end
  end
end
