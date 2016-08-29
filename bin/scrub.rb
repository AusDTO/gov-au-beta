#!/usr/bin/env ruby

# Scrub a PG dump
# Usage: scrub.rb raw.sql > scrubbed.sql

USERS_BEGIN = /^COPY users \(/
SESSIONS_BEGIN = /^COPY sessions \(/
COPY_END = /^\\\./


scrubbed_users = false
scrubbed_sessions = false
scrubbing_users = false
scrubbing_sessions = false
idx = 0
col_index = {}

while line = gets
  if line =~ USERS_BEGIN
    scrubbed_users = true
    scrubbing_users = true
    columns = line.match(/\((.*)\)/).captures[0]
    columns.split(/\s*,\s*/).each_with_index do |val, index|
      col_index[val.to_sym] = index
    end
  elsif line =~ SESSIONS_BEGIN
    scrubbed_sessions = true
    scrubbing_sessions = true
  elsif scrubbing_users
    if line =~ COPY_END
      scrubbing_users = false
    else
    parts = line.split /\t/
    parts[col_index[:email]] = "user-#{idx}@digital.gov.au"
    parts[col_index[:encrypted_password]] = 'REDACTED'
    parts[col_index[:reset_password_token]] = '\N'
    parts[col_index[:current_sign_in_ip]] = '127.0.0.1'
    parts[col_index[:last_sign_in_ip]] = '127.0.0.1'
    parts[col_index[:first_name]] = "User #{idx}"
    parts[col_index[:last_name]] = 'Nameless'
    parts[col_index[:confirmation_token]] = '\N'
    parts[col_index[:unconfirmed_email]] = '\N'
    parts[col_index[:phone_number]] = '0412345678'
    parts[col_index[:encrypted_otp_secret_key]] = '\N'
    parts[col_index[:encrypted_otp_secret_key_iv]] = '\N'
    parts[col_index[:encrypted_otp_secret_key_salt]] = '\N'
    parts[col_index[:direct_otp]] = '\N'
    parts[col_index[:direct_otp_sent_at]] = '\N'
    parts[col_index[:unconfirmed_phone_number]] = '\N'
    parts[col_index[:unconfirmed_phone_number_otp]] = '\N'
    parts[col_index[:unconfirmed_phone_number_otp_sent_at]] = '\N'
    parts[col_index[:unconfirmed_phone_number_otp_sent_at]] = '\N'
    line = parts.join "\t"
    idx += 1
    end
  elsif scrubbing_sessions
    if line =~ COPY_END
      scrubbing_sessions = false
    else
      line = nil
    end
  end

  if line
    puts line
  end
end

raise 'Not scrubbed' if !scrubbed_users || !scrubbed_sessions
