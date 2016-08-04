#!/bin/bash

# Exit immediately if any commands return non-zero
set -e

# Output the commands we run
set -x

# Update the circle envvars for all apps
cf set-env gov-au-beta-blue CIRCLE_SHA1 "$CIRCLE_SHA1"
cf set-env gov-au-beta-green CIRCLE_SHA1 "$CIRCLE_SHA1"

# Update the blue app
cf unmap-route gov-au-beta-blue apps.staging.digital.gov.au -n gov-au-beta
cf push gov-au-beta-blue
cf map-route gov-au-beta-blue apps.staging.digital.gov.au -n gov-au-beta

# Update the green app
cf unmap-route gov-au-beta-green apps.staging.digital.gov.au -n gov-au-beta
cf push gov-au-beta-green
cf map-route gov-au-beta-green apps.staging.digital.gov.au -n gov-au-beta
