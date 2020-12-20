#!/bin/python
# -*- coding: utf-8 -*-
# Get some information about the weather at our location

# imports
import urllib.request, json, location, sys, os, unicodedata
import argparse
import subprocess


# create the parser
parser = argparse.ArgumentParser()

# add arguments
parser.add_argument("--i3bar",
        action="store_true",
        help="Formats the output for the i3bar")
parser.add_argument("--polybar",
        action="store_true",
        help="Formats the output for polybar")
parser.add_argument("--show",
        action="store_true",
        help="Show browser")



args = parser.parse_args()

# get the location
location = location.getlocation()
city=location['city']
country_code=location['countryCode']

# build the url for the weather
weather_api_key = "appid="
weather_unit = "units=metric"
weather_url = "http://api.openweathermap.org/data/2.5/weather?q=" + urllib.parse.quote(city) + "," + country_code + "&" + weather_api_key + "&" + weather_unit

# read the response from the server.
response = urllib.request.urlopen(weather_url)
data = json.loads(response.read())

if args.show:
    show_url = "https://openweathermap.org/city/{}".format(data["id"])
    subprocess.call(['xdg-open', show_url])
    exit()



# weather
weather = data['weather']
descrip = weather[0]['description']
# this would get the icon from open weathermap.
#ico_url = "http://openweathermap.org/img/w/" + weather[0]['icon']


# main stuff
main = data['main']
temp = main['temp']
humidity = main['humidity']

if args.i3bar or args.polybar:
    # weather codes
    # 01 clear sky
    # 02 few clouds
    # 03 scatterd clouds
    # 04 broken clouds
    # 09 shower rain
    # 10 rain
    # 11 thunderstorm
    # 13 snow
    # 50 mist
    weatherDict = {
            '01' : u'\uf185', # does not look that good
            '02' : u'\uf0c2',
            '03' : u'\uf0c2',
            '04' : u'\uf0c2',
            '09' : u'\uf043',
            '10' : u'\uf043',
            '11' : u'\uf0e7',
            '13' : u'\uf2dc',
            '50' : u'\uf0c2'
            }

    icon = weatherDict[weather[0]['icon'][:-1]]
    weatherChar = icon
    degree=u'\u00B0' # unciode for the degree sign
    out=(weatherChar + ' ' + descrip + " " + str(int(temp)) + degree)

    if args.polybar:
        weather=out
    else:
        out += " "
        # format for i3 bar
        color = 'ffffff' # default is white
        if temp > 25: 
            color='ff0000' # hot
        elif temp > 15:
            color='00cc00' # perfect
        elif temp > 5:
            color='ffcc00' # okay
        elif temp <= 5: 
            color='4584dc' # cold

        weather="{ \"full_text\": \"   "+str(out)+"\", \"color\":\"#"+str(color)+"\"},"
    print(weather)
else:
    cloud = ("    .--.   \n" +
            " . (    ). \n" +  
            "(___.__)__)\n")

    snow  = ("    .--.    \n" +
            " . (    ).  \n" +  
            "(___.__)__) \n" +
            " *   *  *   \n" +
            "  *   *  *  \n" + 
            "   *   *  * \n") 

    rain  = ("    .--.     \n" +
            " . (    ).   \n" +  
            "(___.__)__)  \n" +
            " .   .  .    \n" +
            "  .   .   .  \n" +      
            "   .   .   . \n")      

    heavyrain  = ("    .--.     \n" +
            " . (    ).   \n" +  
            "(___.__)__)  \n" +
            " ,   ,  ,    \n" +
            "  ,   ,   ,  \n" +      
            "   ,   ,   , \n")      

    thunder  = ("    .--.     \n" +
            " . (    ).   \n" +  
            "(___.__)__)  \n" +
            " !   ,  !    \n" +
            "  ,  !   ,   \n" +      
            "   !   ,  !, \n")

    sun = ( "    \\     /   \n" +
            "      ,.˛      \n" +
            "  -  (   ) ‒   \n" +
            "      `.`      \n" +
            "      /  \\   ")

    # weather codes
    # 01 clear sky
    # 02 few clouds 
    # 03 scatterd clouds
    # 04 broken clouds
    # 09 shower rain 
    # 10 rain 
    # 11 thunderstorm 
    # 13 snow
    # 50 mist
    weatherDict = {
            '01' : sun, 
            '02' : cloud, 
            '03' : cloud,
            '04' : rain, 
            '09' : rain,
            '10' : heavyrain,
            '11' : thunder, 
            '13' : snow, 
            '50' : cloud
            }

    icon = weatherDict[weather[0]['icon'][:-1]]
    #degree=u'\u00B0' # unciode for the degree sign
    degree="C"
    print(icon)
    print(descrip +" "  +str(temp) + degree)
    print(city)

