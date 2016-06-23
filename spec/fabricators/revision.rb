Fabricator(:revision) do
  revisable { Fabricate(:node) }
end