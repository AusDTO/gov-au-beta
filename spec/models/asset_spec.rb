require 'rails_helper'

RSpec.describe Asset do
  it { should have_attached_file(:asset_file) }
  it { should validate_attachment_presence(:asset_file) }
  it { should validate_attachment_content_type(:asset_file).
      allowing('image/png', 'image/gif').
      rejecting('text/plain', 'text/xml') }
end