class SectionHome < Node

  validates :parent, ancestry_depth: { equals: 1 }
  validates :section, presence: true, uniqueness: true

end
