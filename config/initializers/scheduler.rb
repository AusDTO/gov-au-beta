require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '1h' do |job|
  # clean out old sessions in the database table of sessions
  ClearOldSessionsJob.perform_later
  # randomise next run a multiple of five minutes based on instance index
  job.next_time = Time.now + 60*(5*ENV['CF_INSTANCE_INDEX']) * 60
end