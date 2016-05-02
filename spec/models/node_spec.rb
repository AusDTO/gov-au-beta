require 'rails_helper'

RSpec.describe Node, type: :model do

  it { should belong_to :section }
  it { should belong_to :template }
  it { should belong_to :parent_node }
  it { should have_many :child_nodes }
  it { should have_one :content_block }

end
