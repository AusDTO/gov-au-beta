# WARNING: This class exists to allow creation of custom pages for content types
# we do not yet support. DO NOT USE UNLESS YOU HAVE NO OTHER OPTION.
class CustomTemplateNode < Node
  include SectionHeritage

  validates_with SectionHeritageValidator
  validates_presence_of :section
  validates :parent, ancestry_depth: { minimum: 2 }

  store_attribute :content, :template, String

end