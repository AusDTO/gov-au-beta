class UpdateRootSectionWithRootNode < ActiveRecord::Migration[5.0]
  def up
    if Node.root_node
      root = Node.root_node
      root.associate_root_section
      root.save()
    end
  end
end
