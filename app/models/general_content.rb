class GeneralContent < Node
  include SectionHeritage

  validates_with SectionHeritageValidator
  validates_presence_of :section
  validates :parent, ancestry_depth: { minimum: 2 }, if: :not_root_page?

  def not_root_page?
    not section.is_a? RootSection
  end

  def available_options
    super.merge({toc: 0})
  end
end
