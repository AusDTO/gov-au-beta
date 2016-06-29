#!/usr/bin/env bash

# Exit immediately if there is an error
set -e

# cause a pipeline (for example, curl -s http://sipb.mit.edu/ | grep foo) to produce a failure return code if any command errors not just the last command of the pipeline.
set -o pipefail

# echo out each line of the shell as it executes
set -x

# Update the blue app
cf unmap-route platform-staging-blue apps.staging.digital.gov.au -n govau-platform
cf push platform-staging-blue
cf map-route platform-staging-blue apps.staging.digital.gov.au -n govau-platform

# Update the green app
# cf unmap-route platform-staging-green apps.staging.digital.gov.au -n govau-platform
# cf push platform-staging-green
# cf map-route platform-staging-green apps.staging.digital.gov.au -n govau-platform
