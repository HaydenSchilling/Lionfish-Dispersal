# load my results
library(tidyverse)
library("rnaturalearth")
library("rnaturalearthdata")
library(tidync)


world <- ne_countries(scale = "large", returnclass = "sf")
class(world)

dat_2012a <- hyper_tibble(tidync("Output/Med_Test_output1.nc"))
head(dat_2012a)
dat_2012a$age <- dat_2012a$age/86400
head(dat_2012a)

dat_2012_enda <- dat_2012a %>% filter(age == 26)


dat_2012b <- hyper_tibble(tidync("Output/Med_Test_output2.nc"))
head(dat_2012b)
dat_2012b$age <- dat_2012b$age/86400
head(dat_2012b)

dat_2012_endb <- dat_2012b %>% filter(age == 26)


dat_2012c <- hyper_tibble(tidync("Output/Med_Test_output3.nc"))
head(dat_2012c)
dat_2012c$age <- dat_2012c$age/86400
head(dat_2012c)

dat_2012_endc <- dat_2012c %>% filter(age == 26)

dat_2012_end <- bind_rows(dat_2012_enda,dat_2012_endb, dat_2012_endc)

write_csv(dat_2012_end, "Data/2012_end_points.csv")

head(dat_2012_end)

hist(dat_2012_end$bathy)

map_2012 <- ggplot(dat_2012_end) +
  geom_point(data = dat_2012_end, aes(x = lon, y = lat), size = 1.5, alpha=0.01,
             shape = 21, fill = "blue") +
  geom_sf(data = world, col="grey70", fill = "grey70")+# facet_wrap(~Year)+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  theme_bw() +
  #stat_density2d(mapping= aes(alpha = ..level.. , x = lon, y = lat), geom="polygon", bins=6, size=1)+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

map_2012


end_shallow <- dat_2012_end %>% filter(bathy <= 350)

map_shallow <- ggplot(end_shallow) +
  geom_point(data = end_shallow, aes(x = lon, y = lat), size = 1.5, alpha=0.1,
             shape = 21, fill = "blue") +
  geom_sf(data = world, col="grey70", fill = "grey70")+# facet_wrap(~Year)+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  theme_bw() +
  #stat_density2d(mapping= aes(alpha = ..level.. , x = lon, y = lat), geom="polygon", bins=6, size=1)+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

map_shallow


mydata <- ncdf4::nc_open("Output/Med_Test_output1.nc")
time_origin <- mydata$var$time$units
time_origin2 <- stringr::str_sub(time_origin, 15, 24) # not working
time_origin3 <- stringr::str_sub(time_origin, 26, 33)
time_origin <- paste(time_origin2, " ", time_origin3)
time_origin
ncdf4::nc_close(mydata)

hist(dat_2012_end$time)

dat_2012_end$time <- as.POSIXct(dat_2012_end$time, origin = time_origin)
plot(table(dat_2012_end$time))

### Subset to 1000 particles

next_year_positions <- end_shallow %>% sample_n(size=1000, replace = F)

map_2012_subset <- ggplot(next_year_positions) +
  geom_point(data = next_year_positions, aes(x = lon, y = lat), size = 1.5, alpha=0.07,
             shape = 21, fill = "blue") +
  geom_sf(data = world, col="grey70", fill = "grey70")+# facet_wrap(~Year)+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  theme_bw() +
  #stat_density2d(mapping= aes(alpha = ..level.. , x = lon, y = lat), geom="polygon", bins=6, size=1)+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

map_2012_subset


write_csv(next_year_positions, "Data/2012_end_points_reduced.csv")


### Looking at 2013 results from Katana Run

library(tidyverse)

mydata <- read_csv("Output/2013/2013 results/Shallow_end_points_reduced.csv")


head(mydata)


map_2013_results_subset <- ggplot(mydata) +
  geom_point(data = mydata, aes(x = lon, y = lat), size = 1.5, alpha=0.3,
             shape = 21, fill = "blue") +
  geom_sf(data = world, col="grey70", fill = "grey70")+# facet_wrap(~Year)+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  theme_bw() +
  #stat_density2d(mapping= aes(alpha = ..level.. , x = lon, y = lat), geom="polygon", bins=6, size=1)+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

map_2013_results_subset








########### Investigating the raw ocean model files


dat <- hyper_tibble(tidync("Data/Med_29m_2012.nc"))
head(dat)

dat2 <- dat %>% filter(time ==1325376000)
map_2012 <- ggplot(dat2) +
  geom_sf(data = world, col="grey70", fill = "grey70")+# facet_wrap(~Year)+
  geom_raster(aes(x=lon, y =lat , fill=vomecrty)) +
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  theme_bw() +
  scale_fill_viridis_c()+
  #stat_density2d(mapping= aes(alpha = ..level.. , x = lon, y = lat), geom="polygon", bins=6, size=1)+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

map_2012
