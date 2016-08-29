class ClearOldSessionsJob < ApplicationJob
  queue_as :default

  def perform()
    # run old session cleanup cron
    # https://github.com/rails/activerecord-session_store/blob/master/lib/tasks/database.rake
    cutoff_period = (ENV['SESSION_DAYS_TRIM_THRESHOLD'] || 14).to_i.days.ago
    ActiveRecord::SessionStore::Session.where("updated_at < ?", cutoff_period).delete_all
  end
end
