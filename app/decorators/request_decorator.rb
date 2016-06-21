class RequestDecorator < Draper::Decorator
  delegate_all

  def open?
    object.state == 'requested'
  end

  def closed?
    object.state != 'requested'
  end

  def actioned_status
    if closed?
      "This request was #{object.state} at #{actioned_at} by #{object.approver.decorate.full_name}"
    else
      "Pending"
    end
  end

  def actioned_at
    object.updated_at.strftime("%A, %B %e")
  end
end