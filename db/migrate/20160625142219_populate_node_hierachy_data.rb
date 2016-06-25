class PopulateNodeHierachyData < ActiveRecord::Migration[5.0]
  def up
    # Generate closure_tree hierarchy data for models migrating from acts_as_tree
    # As per (last step) - https://github.com/mceachen/closure_tree#installation
    Node.rebuild!
    SynergyNode.rebuild!
  end

  def down
  end
end
