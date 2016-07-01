#!/bin/bash

# Exit immediately if any commands return non-zero
set -e

# Output the commands we run
set -x

# Update the blue app
cf unmap-route platform-staging-blue apps.staging.digital.gov.au -n staging
cf push platform-staging-blue
cf map-route platform-staging-blue apps.staging.digital.gov.au -n staging

# Update the green app
cf unmap-route platform-staging-green apps.staging.digital.gov.au -n staging
cf push platform-staging-green
cf map-route platform-staging-green apps.staging.digital.gov.au -n staging
