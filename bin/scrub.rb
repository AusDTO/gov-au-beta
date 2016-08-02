#!/usr/bin/env ruby

# Scrub a PG dump
# Usage: scrub.rb raw.sql > scrubbed.sql

USERS_BEGIN = /^COPY users \(/
USERS_END = /^\\\./

scrubbing = false
idx = 0

while line = gets
  if line =~ USERS_BEGIN
    scrubbing = true
  else
    scrubbing = false if line =~ USERS_END

    if scrubbing
      parts = line.split /\t/
      parts[1] = "user-#{idx}@digital.gov.au"
      parts[2] = 'REDACTED'
      parts[13] = "User #{idx}"
      parts[14] = 'Nameless'
      line = parts.join "\t"
      idx += 1
    end
  end

  puts line
end
