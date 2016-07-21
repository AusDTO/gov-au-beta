class RootNode < Node
  validates_absence_of :parent, :slug, :section

  def layout
    'application'
  end
end
