class RootNode < Node
  validates_absence_of :parent, :slug, :section
end
