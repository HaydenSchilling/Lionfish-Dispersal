# -*- coding: utf-8 -*-
"""
Created on Fri Jun  5 13:53:52 2020

@author: htsch
"""
# Code to download Med files run as command line

import motuclient

python3 -m motuclient --motu http://my.cmems-du.eu/motu-web/Motu --service-id MEDSEA_REANALYSIS_PHYS_006_004-TDS --product-id sv03-med-ingv-cur-rean-d --longitude-min -6 --longitude-max 36.25 --latitude-min 30.1875 --latitude-max 45.9375 --date-min "2018-12-01 00:00:00" --date-max "2018-12-31 00:00:00" --depth-min 1.472 --depth-max 1.4722 --variable vomecrty --variable vozocrtx --out-dir "C:\Users\htsch\Documents\GitHub\Lionfish-Dispersal" --out-name "Test_Med.nc" --user "hschillling" --pwd "CMEMS_Schilling_2020#"

motuclient.


## Above does not work...

# explore test file

import netCDF4
import numpy as np

my_example_nc_file = 'C:/Users/htsch/Documents/GitHub/Lionfish-Dispersal/Data/Med_1984_01.nc'
fh = netCDF4.Dataset(my_example_nc_file, mode='r')

fh
