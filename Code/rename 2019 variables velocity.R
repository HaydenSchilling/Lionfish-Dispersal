# rename variables in 2019 files to match older ones

library(ncdf4)

mydata <- nc_open("Data/Med_29m_2019_part1.nc", write = T)
mydata_old <- nc_open("Data/Med_29m_2013_2014.nc")

names(mydata_old$var)
names(mydata$var)

mydata <- ncvar_rename(mydata, "vo", "vomecrty")
mydata <- ncvar_rename(mydata, "uo", "vozocrtx")

names(mydata$var)

nc_close(mydata)

mydata <- nc_open("Data/Med_29m_2019_part2.nc", write = T)

mydata <- ncvar_rename(mydata, "vo", "vomecrty")
mydata <- ncvar_rename(mydata, "uo", "vozocrtx")

nc_close(mydata)

mydata <- nc_open("Data/Med_29m_2020_part1.nc", write = T)

mydata <- ncvar_rename(mydata, "vo", "vomecrty")
mydata <- ncvar_rename(mydata, "uo", "vozocrtx")

nc_close(mydata)

mydata <- nc_open("Data/Med_29m_2020_part2.nc", write = T)

mydata <- ncvar_rename(mydata, "vo", "vomecrty")
mydata <- ncvar_rename(mydata, "uo", "vozocrtx")

nc_close(mydata)
