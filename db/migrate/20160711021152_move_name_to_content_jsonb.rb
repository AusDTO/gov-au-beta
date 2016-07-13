class MoveNameToContentJsonb < ActiveRecord::Migration[5.0]

  class Node < ActiveRecord::Base
    include Storext.model
    self.inheritance_column = :_type_disabled

    store_attribute :content, :name, String
  end

  def up
    Node.all.select { |n| n.name == nil }.each do |n|
      n.name = n.name_before_type_cast
      n.save!
    end
  end
end
