require 'rails_helper'

RSpec.describe LoggingHelper do

  describe '#logging_messages' do
    context 'logs a message' do
      it {
        expect(Rails.logger).to receive(:info).with(/event=test_event/)
        LoggingHelper.log_event(LoggingHelper.current_request, LoggingHelper.current_user, {event: "test_event"})
      }
    end
  end
end

