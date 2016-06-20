# GOV.AU Beta Frontend
This project provides the user facing frontend to the GOV.AU content site.

[![Circle CI](https://circleci.com/gh/AusDTO/gov-au-beta.svg?style=svg&circle-token=e2ad7c1b0e6a0825c4c805e4412d064c98cd23cc)](https://circleci.com/gh/AusDTO/gov-au-beta) [![Code Climate](https://codeclimate.com/repos/576396facfacf40074004a6e/badges/76ba0d87dc83eb9e3202/gpa.svg)](https://codeclimate.com/repos/576396facfacf40074004a6e/feed) [![Test Coverage](https://codeclimate.com/repos/576396facfacf40074004a6e/badges/76ba0d87dc83eb9e3202/coverage.svg)](https://codeclimate.com/repos/576396facfacf40074004a6e/coverage)

## GOV.AU stack
If you're contributing to this repo, then you'll most likely be contributing to the other GOV.AU repos in the stack:

* [GOV.AU Content Analysis](https://github.com/AusDTO/gov-au-beta-content-analysis)
* [Experimental GOV.AU Authoring Tool](https://github.com/AusDTO/gov-au-beta-authoring)

## Dependencies

 - Ruby 2.3.1
 - PostgreSQL 9.4
 - [Content Analysis](https://github.com/AusDTO/gov-au-beta-content-analysis)


## Local Ruby on Rails development environment on Mac OSX


```
# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# install rbenv
brew install rbenv ruby-build

# Add rbenv to bash so that it loads every time you open a terminal
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile

# Install Ruby
rbenv install 2.3.1

# missing openssl.h
brew install openssl
brew link openssl --force

# Can't find the 'libpq-fe.h header
brew install postgresql
initdb /usr/local/var/postgres
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
# logs etc. in /usr/local/var/postgres/

# install deps
bundle install

# Setup environment variables
cp .env.sample .env

# Make any changes you need to (change credentials etc)
$EDITOR .env

```

## Setup and Run Content Analysis Project
See [Content Analysis](https://github.com/AusDTO/gov-au-beta-content-analysis) for detailed instructions.

```
git clone git@github.com:AusDTO/gov-au-beta-content-analysis.git

#Please see project documentation for complete details
```


## Setup and Start the App
```

# setup db with seed data
rails db:setup

# run local dev server at http://localhost:3000
bundle exec rails server
```

## Setting Up/Deploying to cloudfoundry
Thanks to http://docs.cloudfoundry.org/buildpacks/ruby/ruby-tips.html
```
# first time setup
# https://docs.pivotal.io/pivotalcf/devguide/services/migrate-db.html
# http://stackoverflow.com/a/10302357/684978 for db: rake tasks
cf create-service aws-rds-postgres 5.6-t2.micro-5G gov-au-beta-db
cf service gov-au-beta-db # do until status is 'available' - 10 minutes or so
cf push -i 1 -u none -c "bundle exec rake db:schema:load db:seed"
cf set-env gov-au-beta SECRET_KEY_BASE `rails secret`
cf set-env gov-au-beta ROLLBAR_ACCESS_TOKEN aabcc
```


## Development Process

- Use [gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow/)


### Pull requests and branch protection

Branch protection is currently turned on for `develop`, which means that all pull requests
need to pass several tests before they can be merged. The current tests are:

* circleCI - continuous integration to build and execute tests on the branch 
* LGTM - reviewer approval plugin on the pull request

#### Reviewing pull requests

Pull requests currently require approval from at least two people before they can be merged.
After approval has been granted, the PR can be merged by anyone (either the last reviewer
or the author). The list of potential reviewers is stored in the root of the repo, as a 
list of GitHub user accounts in `MAINTAINERS`.

To provide approval for a pull request once satisified with the code:
 * Leave a message of `LGTM` within the main thread of comments.
 * If as a result the build turns green and is ready, use the merge button (unless otherwise
   directed in the PR).

In some instances an author may wish to merge a PR themselves, so it is important to check
the message accompanying the PR to ensure the last reviewer is able to merge. By default,
it is safe to merge a PR as the last reviewer to provide approval.

### Code Climate

To run Code Climate locally, first install the 
[Code Climate CLI](https://github.com/codeclimate/codeclimate), then run
from the root of the repo:
```
codeclimate analyze
```

You can also [view the Code Climate live feed for the `develop` branch](https://codeclimate.com/repos/576396facfacf40074004a6e/feed), but you will need an invitation from someone on your team.
