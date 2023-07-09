library(tidyverse)
library("rnaturalearth")
library("rnaturalearthdata")

file_list <- list.files("Output/Katana/All Shallow/", full.names = T)

full_dat <- data.frame()

for (i in 1:length(file_list)){
  datX <- read_csv(file_list[i])
  full_dat <- bind_rows(full_dat, datX)
}

head(full_dat)
#full_dat

data.table::fwrite(full_dat, "New directory/Shallow_end_points_FINAL.csv")

full_dat <- read_csv("New directory/Shallow_end_points.csv")

mydata <- ncdf4::nc_open("E:/Lionfish/2014/2014_Main_Spawning_994.nc")
#mydata <- ncdf4::nc_open("Output/2013/2013_after_main_spawning_19.nc")
#print(mydata)
time_origin <- mydata$var$time$units
time_origin2 <- stringr::str_sub(time_origin, 15, 24) # not working
time_origin3 <- stringr::str_sub(time_origin, 26, 33)
time_origin <- paste(time_origin2, " ", time_origin3)
time_origin
ncdf4::nc_close(mydata)

full_dat$Date <- as.POSIXct(full_dat$time, origin = time_origin)-26
full_dat$Year <- lubridate::year(full_dat$Date)

data.table::fwrite(full_dat, "New directory/Shallow_end_points_FINAL.csv")


file_list <- list.files("Output/Katana/Reduced Shallow/", full.names = T)

full_dat <- data.frame()

for (i in 1:length(file_list)){
  datX <- read_csv(file_list[i])
  full_dat <- bind_rows(full_dat, datX)
}

head(full_dat)
mydata <- ncdf4::nc_open("E:/Lionfish/2014/2014_Main_Spawning_994.nc")
#mydata <- ncdf4::nc_open("Output/2013/2013_after_main_spawning_19.nc")
#print(mydata)
time_origin <- mydata$var$time$units
time_origin2 <- stringr::str_sub(time_origin, 15, 24) # not working
time_origin3 <- stringr::str_sub(time_origin, 26, 33)
time_origin <- paste(time_origin2, " ", time_origin3)
time_origin
ncdf4::nc_close(mydata)

full_dat$Date <- as.POSIXct(full_dat$time, origin = time_origin)-26
full_dat$Year <- lubridate::year(full_dat$Date)

head(full_dat)

write_csv(full_dat, "New directory/Shallow_end_points_reduced.csv")
