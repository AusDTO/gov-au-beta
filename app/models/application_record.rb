class ApplicationRecord < ActiveRecord::Base
  include AuditLogging
  self.abstract_class = true
end
