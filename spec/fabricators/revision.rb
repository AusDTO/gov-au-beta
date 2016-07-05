Fabricator(:revision) do
  revisable { Fabricate(:node) do
    parent {|attrs| Node.root unless attrs[:parent].present? }
  end }
end
