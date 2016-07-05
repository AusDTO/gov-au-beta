
require 'synergy/cms_import'

class ImportCmsNodesJob < ApplicationJob
  queue_as :default

  def perform(section_id)
    section = Section.find(section_id)
    if section.cms_type == 'GovCMS'
      Synergy::CMSImport.import_from(section)
    end
  end
end
