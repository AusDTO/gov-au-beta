Fabricator(:topic) do
  name { Fabricate.sequence(:topic_name) { |i| "topic-#{i}" } }
end