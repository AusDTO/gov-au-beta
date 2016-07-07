#!/bin/bash

# Exit immediately if any commands return non-zero
set -e

# Output the commands we run
set -x

# Update the blue app
cf unmap-route gov-au-beta-blue apps.staging.digital.gov.au -n gov-au-beta
cf push gov-au-beta-blue || cf push gov-au-beta-blue || cf push gov-au-beta-blue
cf map-route gov-au-beta-blue apps.staging.digital.gov.au -n gov-au-beta

# Update the green app
cf unmap-route gov-au-beta-green apps.staging.digital.gov.au -n gov-au-beta
cf push gov-au-beta-green || cf push gov-au-beta-green || cf push gov-au-beta-green
cf map-route gov-au-beta-green apps.staging.digital.gov.au -n gov-au-beta
