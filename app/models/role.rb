class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  # Required by administrate to set the resource using a single parameter
  def resource_type_and_id
    "#{resource_type}-#{resource_id}"
  end

  def resource_type_and_id=(arg)
    if arg.blank?
      self.resource = nil
    elsif m = /([\w\d]+)-([\d]+)/.match(arg)
      self.resource_type = m[1]
      self.resource_id = m[2]
    end
  end
end
