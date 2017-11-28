#!/bin/bash

echo "ups_as_envs script"
eval $(./bin/ups_as_envs.py)

RAILS_ENV=$RAILS_ENV bundle exec rake cf:on_first_instance db:migrate && exec bundle exec rails s -p $PORT -e $RAILS_ENV
