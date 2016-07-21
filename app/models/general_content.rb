class GeneralContent < Node
  include SectionHeritage

  validates_with SectionHeritageValidator
  validates_presence_of :section
  validates :parent, ancestry_depth: { minimum: 2 }

  def available_options
    super.merge({toc: 0})
  end
end
