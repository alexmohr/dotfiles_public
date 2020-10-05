#!/bin/python
# -*- coding: utf-8 -*-
# Get some information about the weather at our location

# imports
import argparse
import json
import location
import sys
import os
import unicodedata

import urllib.request
import urllib.parse
import subprocess


# create the parser
parser = argparse.ArgumentParser()

parser.add_argument("--gmaps",
        action="store_true",
        help="Open google maps")

parser.add_argument("--debug",
        action="store_true",
        help="Print debug statements")

args = parser.parse_args()


# get the location
location = location.getlocation()
city = location['city']
country_code = location['countryCode']

BASE_URL = "https://creativecommons.tankerkoenig.de/json/list.php"
# LAT=48.3515503
# LONG=9.9666895
API_KEY = "KEY"
FUEL = "diesel"
SORT = "price"
RADIUS = "10"
url_path = "?lat=" + str(location["lat"]) +\
        "&lng="+  str(location["lon"])  +\
        "&sort=" + SORT +\
        "&type=" + FUEL +\
        "&rad=" + RADIUS +\
        "&apikey="+ API_KEY
url=urllib.parse.urljoin(BASE_URL, url_path)
response = urllib.request.urlopen(url)
data = json.loads(response.read())
for station in data["stations"]:
    price=station["price"]
    if price is not None:
        fuel_price = price
        break

if args.debug:
    print("location {}".format(location))
    print("station: {}".format(station))

if not args.gmaps:
    print('{:0.2f}€'.format(round(price, 2)))
else:
    url="https://www.google.com/maps?q={},{}".format(station["lat"], station["lng"])
    subprocess.call(['xdg-open', url])
