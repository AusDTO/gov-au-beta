# GOV.AU Beta Frontend
This project provides the user facing frontend to the GOV.AU content site.

[![Circle CI](https://circleci.com/gh/AusDTO/gov-au-beta.svg?style=svg&circle-token=e2ad7c1b0e6a0825c4c805e4412d064c98cd23cc)](https://circleci.com/gh/AusDTO/gov-au-beta)

## Local Ruby on Rails development environment on Mac OSX
```
#install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#install rbenv
brew install rbenv ruby-build

# Add rbenv to bash so that it loads every time you open a terminal
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile

# Install Ruby
rbenv install 2.3.0

#missing openssl.h
brew install openssl
brew link openssl --force
#Can't find the 'libpq-fe.h header
brew install postgresql
initdb /usr/local/var/postgres
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
# logs etc. in /usr/local/var/postgres/
#install deps
bundle install
# setup db with seed data
rails db:setup
# set environment variables
export AUTHORING_BASE_URL=http://localhost:8083
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
cf set-env gov-au-beta AUTHORING_BASE_URL http://localhost:8083
cf set-env gov-au-beta ROLLBAR_ACCESS_TOKEN aabcc
```


