require "administrate/field/base"
require 'synergy/cms_import'

class CmsTypeField < Administrate::Field::Base
  def self.form_name
    'cms_type'
  end

  def to_s
    data
  end

  def selected_option
    data
  end

  def select_options
    ::Synergy::CMSImport::ADAPTERS.keys.map do |cms_type|
      [cms_type, cms_type]
    end
  end
end

