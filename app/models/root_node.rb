class RootNode < Node
  validates_absence_of :parent, :slug, :section

  def layout
    'root'
  end
end
