# Final output manip

library(tidyverse)
library(rnaturalearth)
library(rnaturalearthdata)

file_list <- list()
file_list[[1]] <- read_csv("/srv/scratch/z3374139/Lionfish/2013/Shallow_end_points_reduced.csv")
file_list[[2]] <- read_csv("/srv/scratch/z3374139/Lionfish/2014/Shallow_end_points_reduced.csv")
file_list[[3]] <- read_csv("/srv/scratch/z3374139/Lionfish/2015/Shallow_end_points_reduced.csv")
file_list[[4]] <- read_csv("/srv/scratch/z3374139/Lionfish/2016/Shallow_end_points_reduced.csv")
file_list[[5]] <- read_csv("/srv/scratch/z3374139/Lionfish/2017/Shallow_end_points_reduced.csv")
file_list[[6]] <- read_csv("/srv/scratch/z3374139/Lionfish/2018/Shallow_end_points_reduced.csv")
file_list[[7]] <- read_csv("/srv/scratch/z3374139/Lionfish/2019/Shallow_end_points_reduced.csv")


full_dat <- bind_rows(file_list)

head(full_dat)
#full_dat

full_dat$Date <- as.Date(full_dat$Date)
full_dat$Year <- lubridate::year((full_dat$Date-26))

world <- ne_countries(scale = "large", returnclass = "sf")
class(world)

map_ <- ggplot(full_dat) +
  geom_point(data = full_dat, aes(x = lon, y = lat), size = 1, alpha=0.1,
             shape = 21, fill = "blue") +
  geom_sf(data = world, col="grey70", fill = "grey70")+ facet_wrap(~Year)+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  theme_bw() +
  #stat_density2d(mapping= aes(alpha = ..level.. , x = lon, y = lat), geom="polygon", bins=6, size=1)+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

map_

ggsave("Final Test.png", dpi = 600, height = 21, width = 29.5, units = "cm")

## Full end points

file_list <- list()
file_list[[1]] <- read_csv("/srv/scratch/z3374139/Lionfish/2013/Full_end_points.csv")
file_list[[2]] <- read_csv("/srv/scratch/z3374139/Lionfish/2014/Full_end_points.csv")
file_list[[3]] <- read_csv("/srv/scratch/z3374139/Lionfish/2015/Full_end_points.csv")
file_list[[4]] <- read_csv("/srv/scratch/z3374139/Lionfish/2016/Full_end_points.csv")
file_list[[5]] <- read_csv("/srv/scratch/z3374139/Lionfish/2017/Full_end_points.csv")
file_list[[6]] <- read_csv("/srv/scratch/z3374139/Lionfish/2018/Full_end_points.csv")
file_list[[7]] <- read_csv("/srv/scratch/z3374139/Lionfish/2019/Full_end_points.csv")


full_dat <- bind_rows(file_list)

head(full_dat)
#full_dat

full_dat$Date <- as.Date(full_dat$Date)
full_dat$Year <- lubridate::year((full_dat$Date-26))

world <- ne_countries(scale = "large", returnclass = "sf")
class(world)

map_ <- ggplot(full_dat) +
  geom_point(data = full_dat, aes(x = lon, y = lat), size = 1, alpha=0.1,
             shape = 21, fill = "blue") +
  geom_sf(data = world, col="grey70", fill = "grey70")+ facet_wrap(~Year)+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  theme_bw() +
  #stat_density2d(mapping= aes(alpha = ..level.. , x = lon, y = lat), geom="polygon", bins=6, size=1)+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

map_

ggsave("Final Test full points.png", dpi = 600, height = 21, width = 29.5, units = "cm")