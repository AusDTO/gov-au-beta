class UpdateRootSectionWithRootNode < ActiveRecord::Migration[5.0]
  def up
    root = Node.root_node
    root.associate_root_section
    root.save()
  end
end
