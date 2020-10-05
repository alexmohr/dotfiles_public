#!/bin/python
# Gets the current location as json data.


import urllib.request, json

def getlocation():
	# Automatically geolocate the connecting IP
	#url = 'http://freegeoip.net/json/'
        url = 'http://ip-api.com/json'
        response = urllib.request.urlopen(url)
        return json.loads(response.read())
