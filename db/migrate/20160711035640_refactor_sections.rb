class RefactorSections < ActiveRecord::Migration[5.0]

  class Node < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Section < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    # First cull any stray section-less orphans
    Node.where(section_id: nil).where(parent_id: nil).delete_all

    # Make a root node (global homepage)
    root = Node.create name: '',
      type: 'RootNode',
      state: 'published'

    # Make a homepage node for each section with root node as parent
    Section.all.each do |section|
      home = Node.create name: section.name,
        type: 'SectionHome',
        slug: section.name.parameterize,
        section_id: section.id,
        state: 'published',
        parent_id: root.id

      # Adopt orphans
      Node.where(section_id: section.id).where(parent_id: nil).each do |node|
        node.update_attribute :parent_id, home.id
      end
    end
  end

  def down
    root = Node.where(parent_id: nil).first

    Node.where(parent_id: root.id).each do |home_node|
      Node.where(parent_id: home_node.id).each do |node|
        node.update_column :parent_id, nil # Disown children
      end

      # Kill parent
      home_node.delete
    end

    # Smash patriarchy
    root.delete
  end
end
