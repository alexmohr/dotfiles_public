#!/bin/python
# Get our wan location

# imports
import location

# get the location
location = location.getlocation()
print ('WAN: ' +  location['countryCode'])
