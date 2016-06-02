Fabricator(:preview) do
  token { SecureRandom.urlsafe_base64 }
end

Fabricator(:populated_preview, from: :preview) do
  content_blocks {[{ 'body' => '<p>Hello!</p>' }]}
  template 'default'
  section { { 'name' => 'Communications', 'layout' => 'communications' } }
end