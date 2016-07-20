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

### Mailtrap

We use [Mailtrap](https://mailtrap.io) for development email testing.
To configure Mailtrap, create an account (the free version is fine)
and view the inbox to get your SMTP username and password. Add these to your
environment or `.env` file as `MAILTRAP_USERNAME` and
`MAILTRAP_PASSWORD`.

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

## Production Deployment

Production URL is https://gov-au-beta-blue.apps.platform.digital.gov.au/

To deploy to Production, tag the desired branch with a version number and push.

`git tag v0.01`

CircleCI will run the test suite and deploy to production on pass.


## Migrating data between RDS instances

There may occasionally be a need to migrate data from one RDS instance to another.
In these instanes, you will require:

* CF access to the environments the RDS instances run on
* Access to a jumpbox  to connect directly to the amazon RDS instances

The latter can be set up by the webops team, but needs to be performed behind
a whitelisted IP (typicaly the office).

As CloudFoundry picks owner and database names for the RDS instances, we need to
produce an export that has no ownership or privileges. We can find the CF
credentials for these instances in the environment variables for an application
that is bound to them.

* SSH into the jump-box that has access to the source RDS instance
* `pg_dump --no-owner --no-acl -h SRC_RDS_HOST -U SRC_RDS_USERNAME -W SRC_RDS_NAME  > db.sql`
  * You will need to provide the SRC_RDS_PASSWORD
* If local migrations need to be run on this, SCP the file to your local machine,
  run the necessary migrations, and SCP the file back.
* If the target RDS instance is on a different subnet from the source, you will need
  to SCP the db dump to a jump-box on that subnet.
* With the target file: `psql -h TARGET_RDS_HOST -U TARGET_RDS_USERNAME -W -d TARGET_RDS_NAME < db.sql`
  * YOu will need to provide the TARGET_RDS_PASSWORD

## Blue / Green deploys

Deployments occur to two applications that run off the same RDS instance - blue and
green. They are deployed one at a time so that there is always at least one
application that is routable, in order to minimize downtime for the end-user.

There is an issue when binding multiple apps to the one RDS instance, whereby
the second app to be bound has permissions issues and cannot access the data
necessary to successfully start. As such, the secondary app must be started
without a bound service, and must instead reference the absolute URL of the
database manually using the `DATABASE_URL` environment variable. This environment
variable can be obtained from the environment variable list of the application
already bound to the service (there must be one).

Given this, the manifest.yml file does not need to declare a service for the
application (as this would cause both applications to bind to the service during
a push, which breaks for one). This must be done manually when creating a new
environment for the first time, and will not happen automatically as part of 
any push command.


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


## Layouts

The application uses nested layouts (using the inside_layout method inside ApplicationHelper).

* Public facing pages all use or are nested within app/views/layouts/application.html.haml.
* Sections use app/views/layouts/section.html.haml
* Custom section layouts should be nested inside section. For example:

```
= inside_layout('section') do
  / Your markup
  = yield
```

## Node types

To create a new node type, do the following:

* Create a model class that extends `Node`
* Update `node.rb` to require the new model file
* Add any versioned attributes as `content_attributes` and other attributes as `store_attributes`
* Run `rails g administrate:dashboard <node_class>`
* Update the dashboard to extend `NodeDashboard` (see `NewsArticleDashboard` as an example)
* Update `routes.rb` with a resource for the admin namespace
* Add a locale entry for `domain_model.nodes.<node_class>`
* Update the new node, new submission and edit node forms for any new fields
* Add the node type to list in `Editorial::NodeController#prepare`
* Create a template in `views/templates/<node_class>`
* If required, create a subclass of `NodeDecorator` with class specific decorator logic
* If required, update `seeds.rb` to have examples of the node type
* Create tests to verify subclass specific logic
