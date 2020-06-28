
library(ncdf4)
library(tidyverse)


mydata <- nc_open("Data/Med_1984_01.nc")
mydata <- nc_open("Data/Temp_Med_1987_01.nc")
#View a summary of the Parcels output

print(mydata)

# get lat/long

lon <- ncvar_get(mydata,"lon_rho")
nlon <- dim(lon)
#head(lon)
lat <- ncvar_get(mydata,"lat_rho")
nlat <- dim(lat)
#head(lat)
print(head(c(nlon,nlat)))

plot(lon, lat)

# Make Time variable
time_array <- ncvar_get(mydata,"time")
dlname <- ncatt_get(mydata,"time","long_name")
dunits <- ncatt_get(mydata,"time","units")
fillvalue <- ncatt_get(mydata,"time","_FillValue")
dim(time_array)


time_origin <- mydata$var$time$units
time_origin2 <- str_sub(dunits[2], 15, 24)
time_origin3 <- str_sub(dunits[2], 26, 33)
time_origin <- paste(time_origin2, " ", time_origin3)
time_origin


# convert time from seconds since origin. Orgin is specified in the units for time. This probably needs to be automated as the origin may change next time.
total_data <- as.POSIXct(time_array, origin = time_origin) # from info in netCDF file
total_data$Month <- month(total_data$Time) #, label = TRUE
total_data$Year <- year(total_data$Time)
head(total_data)

nc_close(mydata)
