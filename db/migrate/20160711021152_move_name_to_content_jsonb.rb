class MoveNameToContentJsonb < ActiveRecord::Migration[5.0]
  def up
    Node.all.select { |n| n.name == nil }.each do |n|
      n.name = n.name_before_type_cast
      n.save!
    end
  end
end
