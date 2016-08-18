#!/usr/bin/env ruby

# Scrub a PG dump
# Usage: scrub.rb raw.sql > scrubbed.sql

USERS_BEGIN = /^COPY users \(/
USERS_END = /^\\\./

scrubbing = false
scrubbed = false
idx = 0
col_index = {}

while line = gets
  if line =~ USERS_BEGIN
    scrubbing = true
    scrubbed = true
    columns = line.match(/\((.*)\)/).captures[0]
    columns.split(/\s*,\s*/).each_with_index do |val, index|
      col_index[val.to_sym] =  index
    end
  else
    scrubbing = false if line =~ USERS_END

    if scrubbing
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
  end

  puts line
end

raise 'Not scrubbed' if scrubbing || !scrubbed
