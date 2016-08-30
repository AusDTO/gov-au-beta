require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '1h' do |job|
  # clean out old sessions in the database table of sessions
  ClearOldSessionsJob.perform_later
  # randomise next run a multiple of five minutes based on instance index
  index = 0
  if ENV['CF_INSTANCE_INDEX']
    index = ENV['CF_INSTANCE_INDEX'].to_i
  end
  job.next_time = Time.now + 60*(5*index) * 60
end