#!/usr/bin/env ruby

# The file is used by the `git secrets` subcommand to blacklist patterns that look
# like production environment variables being committed to the git repo.
#
# To install git-secrets, run `brew install git-secrets` then in the project directory
# run `git secrets --install`, then `git secrets --add-provider ./git-secret-patterns.rb`.
#
# This file contains a list of patterns that will cause a commit to be aborted
# if any change that the commit introduces contains lines matching any of these
# patterns.
#
# If it is determined that that match is a false positive, the commit hook may
# be bypassed by passing the `--no-verify` switch to the `git commit` command.

DATA.each_line{|l| puts l}

__END__
VCAP_SERVICES
VCAP_APPLICATION
BLUE_GREEN_URL
DATABASE_URL
GOOGLE_TAG_MANAGER_ID
HTTP_PASSWORD
HTTP_USERNAME
NEW_RELIC_APP_NAME
NEW_RELIC_LICENSE_KEY
ROLLBAR_ACCESS_TOKEN
SECRET_KEY_BASE
SEED_USER_PASSWORD
SMS_CONSUMER_KEY
SMS_CONSUMER_SECRET
TFA_SECRET_KEY
[A-Z]+(_[A-Z0-9]+)*\s?[=:]
