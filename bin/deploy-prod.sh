#!/usr/bin/env bash

# Exit immediately if there is an error
set -e

# cause a pipeline (for example, curl -s http://sipb.mit.edu/ | grep foo) to produce a failure return code if any command errors not just the last command of the pipeline.
set -o pipefail

# echo out each line of the shell as it executes
set -x

# Update the blue app
cf unmap-route gov-au-beta-blue apps.platform.digital.gov.au -n gov-au-beta
cf push gov-au-beta-blue
cf map-route gov-au-beta-blue apps.platform.digital.gov.au -n gov-au-beta

# Update the green app
cf unmap-route gov-au-beta-green apps.platform.digital.gov.au -n gov-au-beta
cf push gov-au-beta-green
cf map-route gov-au-beta-green apps.platform.digital.gov.au -n gov-au-beta
