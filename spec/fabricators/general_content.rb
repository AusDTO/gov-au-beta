Fabricator(:general_content, from: :node, class_name: :general_content) do
  name { Fabricate.sequence(:general_content_name) { |i| "general_content-#{i}" } }
end