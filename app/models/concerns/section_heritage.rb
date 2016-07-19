=begin

This module should be included in any Node subclasses instance of which
should automatically inherit their section from the parent.

=end

module SectionHeritage
  extend ActiveSupport::Concern

  included do
    before_validation :inherit_section
  end

  def inherit_section
    if section.nil? && parent.present? && parent.section.present?
      self.section = parent.section
    end
  end
end
