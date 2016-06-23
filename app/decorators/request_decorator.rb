class RequestDecorator < Draper::Decorator
  decorates_association :approver, with: UserDecorator
  delegate_all
  delegate :name, to: :section, prefix: true
  delegate :full_name, to: :approver, allow_nil: true, prefix: true

  def open?
    object.state == 'requested'
  end

  def closed?
    object.state != 'requested'
  end

  def actioned_status
    if closed?
      "This request was #{object.state} at #{actioned_at} by #{approver_full_name}"
    else
      "Pending"
    end
  end

  def actioned_at
    object.updated_at.strftime("%A, %B %e")
  end
end
