module AuditLogging
  extend ActiveSupport::Concern

  # The sequence for calling ActiveRecord::Base#save for an existing record is similar, except
  # that each _create callback is replaced by the corresponding _update callback.
  # http://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html
  included do
    after_update :after_update
    after_create :after_create
    after_destroy :after_destroy
  end

  def after_update
    audit(self, "update_record")
  end
  def after_create
    audit(self, "create_record")
  end
  def after_destroy
    audit(self, "destroy_record")
  end

  def audit(record,action)
    data = {event:action, record_id: record.id, record_type: record.class}
    #get current user and request from the Thread
    LoggingHelper.log_event(LoggingHelper.current_request, LoggingHelper.current_user, data)
  end
end