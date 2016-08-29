class RootNode < Node
  validates_absence_of :parent, :slug
  before_create :associate_root_section

  def layout
    'root'
  end

  def associate_root_section
    if not self.section_id
      #create a root section if not created
      if not RootSection.first
        RootSection.new.save()
      end
      self.section_id = RootSection.first.id
    end
  end
end
