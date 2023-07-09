# Merge parcels outputs

# load my results
library(tidyverse)
library(tidync)


#world <- ne_countries(scale = "large", returnclass = "sf")
#class(world)

full_dat <- data.frame()

file_list <- list.files(path = "/srv/scratch/z3374139/Lionfish/Forward/From 2021/", pattern = ".nc", full.names = TRUE)

for (i in 1:length(file_list)){
  datX <- hyper_tibble(tidync(file_list[i]))
  full_dat <- bind_rows(full_dat, datX)
}

mydata <- ncdf4::nc_open(file_list[i])
#mydata <- ncdf4::nc_open("Output/2013/2013_after_main_spawning_19.nc")
#print(mydata)
time_origin <- mydata$var$time$units
time_origin2 <- stringr::str_sub(time_origin, 15, 24) # not working
time_origin3 <- stringr::str_sub(time_origin, 26, 33)
time_origin <- paste(time_origin2, " ", time_origin3)
time_origin
ncdf4::nc_close(mydata)

full_dat$Date <- as.POSIXct(full_dat$time, origin = time_origin)

full_dat$age <- full_dat$age/86400

write_csv(full_dat, "/srv/scratch/z3374139/Lionfish/Forward/From 2021/Full_paths.csv")

full_dat <- full_dat %>% filter(age == 26)

write_csv(full_dat, "/srv/scratch/z3374139/Lionfish/Forward/From 2021/Full_end_points.csv")

full_dat <- full_dat %>% filter(bathy <= 350 & bathy > 0)

write_csv(full_dat, "/srv/scratch/z3374139/Lionfish/Forward/From 2021/Shallow_end_points.csv")

full_dat <- full_dat %>% sample_n(size=1000, replace = F)

write_csv(full_dat, "/srv/scratch/z3374139/Lionfish/Forward/From 2021/Shallow_end_points_reduced.csv")

