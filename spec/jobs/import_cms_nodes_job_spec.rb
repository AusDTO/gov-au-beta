require 'rails_helper'

RSpec.describe ImportCmsNodesJob, type: :job do
  let(:section) { Fabricate(:section, cms_type: "GovCMS") }
  let(:collaborate_section) { Fabricate(:section, cms_type: "Collaborate") }

  it "invokes the importer for the section provided" do
    expect(Synergy::CMSImport).to receive(:import_from).with(section).and_return(nil)
    ImportCmsNodesJob.perform_now(section.id)
  end

  it "ignores non-GovCMS sections" do
    expect(Synergy::CMSImport).not_to receive(:import_from)
    ImportCmsNodesJob.perform_now(collaborate_section.id)
  end
end
