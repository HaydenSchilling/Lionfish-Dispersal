# Final output manip

library(tidyverse)
library(rnaturalearth)
library(rnaturalearthdata)

file_list <- list()
#file_list[[1]] <- read_csv("E:/Lionfish/Forward/From 2019/Shallow_end_points.csv")
file_list[[1]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2019/Shallow_end_points.csv")
file_list[[2]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2020/Shallow_end_points.csv")
file_list[[3]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2021/Shallow_end_points.csv")
file_list[[4]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2022/Shallow_end_points.csv")
file_list[[5]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2023/Shallow_end_points.csv")
file_list[[6]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2024/Shallow_end_points.csv")
file_list[[7]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2025/Shallow_end_points.csv")
file_list[[8]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2026/Shallow_end_points.csv")
file_list[[9]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2027/Shallow_end_points.csv")
file_list[[10]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2028/Shallow_end_points.csv")
file_list[[11]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2029/Shallow_end_points.csv")


file_list[[1]]$Year <- 2020
file_list[[2]]$Year <- 2021
file_list[[3]]$Year <- 2022
file_list[[4]]$Year <- 2023
file_list[[5]]$Year <- 2024
file_list[[6]]$Year <- 2025
file_list[[7]]$Year <- 2026
file_list[[8]]$Year <- 2027
file_list[[9]]$Year <- 2028
file_list[[10]]$Year <- 2029
file_list[[11]]$Year <- 2030


full_dat <- bind_rows(file_list)

head(full_dat)
#full_dat

#full_dat$Date <- as.Date(full_dat$Date)
#full_dat$Year <- lubridate::year((full_dat$Date-26))+1

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

ggsave("Final Test_forcast.png", dpi = 600, height = 21, width = 29.5, units = "cm")

## Full end points

file_list <- list()
file_list[[1]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2019/Full_end_points.csv")
file_list[[2]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2020/Full_end_points.csv")
file_list[[3]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2021/Full_end_points.csv")
file_list[[4]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2022/Full_end_points.csv")
file_list[[5]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2023/Full_end_points.csv")
file_list[[6]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2024/Full_end_points.csv")
file_list[[7]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2025/Full_end_points.csv")
file_list[[8]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2026/Full_end_points.csv")
file_list[[9]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2027/Full_end_points.csv")
file_list[[10]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2028/Full_end_points.csv")
file_list[[11]] <- read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2029/Full_end_points.csv")



file_list[[1]]$Year <- 2020
file_list[[2]]$Year <- 2021
file_list[[3]]$Year <- 2022
file_list[[4]]$Year <- 2023
file_list[[5]]$Year <- 2024
file_list[[6]]$Year <- 2025
file_list[[7]]$Year <- 2026
file_list[[8]]$Year <- 2027
file_list[[9]]$Year <- 2028
file_list[[10]]$Year <- 2029
file_list[[11]]$Year <- 2030

full_dat <- bind_rows(file_list)

head(full_dat)
#full_dat

#full_dat$Date <- as.Date(full_dat$Date)
#full_dat$Year <- lubridate::year((full_dat$Date-26))+1

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

ggsave("Final Test full points_forecast.png", dpi = 600, height = 21, width = 29.5, units = "cm")