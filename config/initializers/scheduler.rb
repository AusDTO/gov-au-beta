require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

if (ENV['CF_INSTANCE_INDEX'] && ENV['CF_INSTANCE_INDEX'] == '0') || !ENV['CF_INSTANCE_INDEX']
  s.every '1h' do |job|
    # clean out old sessions in the database table of sessions
    ClearOldSessionsJob.perform_later
  end
end