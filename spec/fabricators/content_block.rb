Fabricator(:content_block) do 
  body { Fabricate.sequence(:content_block_body) { |i| "Random content #{i}" } }
end