#!/usr/bin/python
# Weather script for i3blocks, data taken from yr.no
#
#«Weather forecast from Yr,
#  delivered by the Norwegian Meteorological Institute and NRK#»

import urllib.request
import xml.etree.ElementTree as ET

# Symbols
s_sun = "";
s_cloud = "";
s_rain = "";
s_wind = "";
s_snow = "";

def main():
    fp = urllib.request.urlopen('https://www.yr.no/place/sweden/stockholm/stockholm/forecast_hour_by_hour.xml')
    mybytes = fp.read()
    mystr = mybytes.decode('utf-8')
    fp.close()

    root = ET.fromstring(mystr)
    forecast = root.find("./forecast/tabular/time")
    temperature = forecast.find("./temperature").attrib.get("value")
    symbol = int(forecast.find("./symbol").attrib.get("number"))

    # Symbol numbers:
    # 1: clear sky
    # 2: Fair
    # 3: Partly Cloudy
    # 4: Cloudy
    # 5: Rain
    # 6: rain and thunder
    # 7: Sleet
    # 8: Snow
    # 9: rain

    if symbol == 1 or symbol == 2:
        print(s_sun,end='')
    elif symbol == 3 or symbol == 4:
        print(s_cloud,end='')
    elif symbol == 5 or symbol == 6 or symbol == 9:
        print(s_rain,end='')
    elif symbol == 7 or symbol == 8:
        print(s_snow,end='')
        
    print(' '+temperature+"°C")

if __name__ == "__main__":
    main()
