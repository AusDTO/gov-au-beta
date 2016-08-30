module AuditLogging
  extend ActiveSupport::Concern

  # http://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html
  included do
    after_save :after_save
    after_create :after_create
    after_destroy :after_destroy
  end

  def after_save
    audit(self, "save_record")
  end
  def after_create
    audit(self, "create_record")
  end
  def after_destroy
    audit(self, "destroy_record")
  end

  def audit(record,action)
    data = {event:action, record_id: record.id, record_type: record.class, record_name: record.try("name"), record_slug: record.try("slug")}
    #get current user and request from the Thread
    LoggingHelper.log_event(LoggingHelper.current_request, LoggingHelper.current_user, data)
  end
end