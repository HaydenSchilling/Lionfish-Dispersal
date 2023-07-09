# Bathymetry merging

library(raster)

mydata1 <- raster("Data/Bathymetry/E5_2018.nc", varname="DEPTH")
mydata2 <- raster("Data/Bathymetry/E6_2018.nc", varname="DEPTH")
mydata3 <- raster("Data/Bathymetry/F4_2018.nc", varname="DEPTH")
mydata4 <- raster("Data/Bathymetry/F5_2018.nc", varname="DEPTH")
mydata5 <- raster("Data/Bathymetry/F6_2018.nc", varname="DEPTH")
mydata6 <- raster("Data/Bathymetry/F7_2018.nc", varname="DEPTH")
mydata7 <- raster("Data/Bathymetry/F8_2018.nc", varname="DEPTH")
mydata8 <- raster("Data/Bathymetry/G6_2018.nc", varname="DEPTH")
mydata9 <- raster("Data/Bathymetry/G7_2018.nc", varname="DEPTH")
mydata10 <- raster("Data/Bathymetry/G8_2018.nc", varname="DEPTH")
plot(mydata9)

comb <- mosaic(mydata1, mydata3,mydata3,mydata4,mydata5,mydata6,mydata7,mydata8,mydata9,mydata10, fun = "mean")
plot(comb)

writeRaster(x = comb, filename = "Data/Bathymetry/Full Med.tif")
