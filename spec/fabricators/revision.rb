Fabricator(:revision) do
  revisable { Fabricate(:node) do
    parent {|attrs| Node.root_node unless attrs[:parent].present? }
  end }
end
