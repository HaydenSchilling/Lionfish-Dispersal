# Final output manip

library(tidyverse)
library(rnaturalearth)
library(rnaturalearthdata)

file_list <- list()
#file_list[[1]] <- read_csv("E:/Lionfish/Forward/From 2019/Shallow_end_points.csv")
#file_list[[1]] <- read_csv("/srv/scratch/z3374139/Lionfish/2012/Shallow_end_points_reduced.csv")
#file_list[[1]] <- read_csv("Output/Katana/All Shallow/2012_end_points_reduced.csv") %>%
file_list[[1]] <- read_csv("/srv/scratch/z3374139/Lionfish/2012_end_points_reduced.csv") %>%
  
  dplyr::select(lat, lon)

#head(file_list[[1]])

mydata <- file_list[[1]]
#head(mydata)
mydata$Year <- 2013
full_data <- mydata
for (i in 2014:2020){
  mydataX <- mydata
  mydataX$Year=i
  full_data <- bind_rows(full_data, mydataX)
}
file_list[[1]] <- full_data

#file_list[[2]] <- read_csv("/srv/scratch/z3374139/Lionfish/2013/Shallow_end_points.csv")
#file_list[[2]] <- read_csv("Output/Katana/All Shallow/2013_Shallow_end_points.csv")  %>%
  file_list[[2]] <- read_csv("/srv/scratch/z3374139/Lionfish/2013_Shallow_end_points.csv") %>%
  dplyr::select(lat, lon)

mydata <- file_list[[2]]
#head(mydata)
mydata$Year <- 2014
full_data <- mydata
for (i in 2015:2020){
  mydataX <- mydata
  mydataX$Year=i
  full_data <- bind_rows(full_data, mydataX)
}
file_list[[2]] <- full_data


#file_list[[3]] <- read_csv("/srv/scratch/z3374139/Lionfish/2014/Shallow_end_points.csv")
#file_list[[3]] <- read_csv("Output/Katana/All Shallow/2014_Shallow_end_points.csv") %>%
file_list[[3]] <- read_csv("/srv/scratch/z3374139/Lionfish/2014_Shallow_end_points.csv") %>%
dplyr::select(lat, lon)

mydata <- file_list[[3]]
#head(mydata)
mydata$Year <- 2015
full_data <- mydata
for (i in 2016:2020){
  mydataX <- mydata
  mydataX$Year=i
  full_data <- bind_rows(full_data, mydataX)
}
file_list[[3]] <- full_data


#file_list[[4]] <- read_csv("/srv/scratch/z3374139/Lionfish/2015/Shallow_end_points.csv")
#file_list[[4]] <- read_csv("Output/Katana/All Shallow/2015_Shallow_end_points.csv") %>%
file_list[[4]] <- read_csv("/srv/scratch/z3374139/Lionfish/2015_Shallow_end_points.csv") %>%
  dplyr::select(lat, lon)

mydata <- file_list[[4]]
#head(mydata)
mydata$Year <- 2016
full_data <- mydata
for (i in 2017:2020){
  mydataX <- mydata
  mydataX$Year=i
  full_data <- bind_rows(full_data, mydataX)
}
file_list[[4]] <- full_data

#file_list[[5]] <- read_csv("/srv/scratch/z3374139/Lionfish/2016/Shallow_end_points.csv")
#file_list[[5]] <- read_csv("Output/Katana/All Shallow/2016_Shallow_end_points.csv") %>%
file_list[[5]] <- read_csv("/srv/scratch/z3374139/Lionfish/2016_Shallow_end_points.csv") %>%
  dplyr::select(lat, lon)

mydata <- file_list[[5]]
#head(mydata)
mydata$Year <- 2017
full_data <- mydata
for (i in 2018:2020){
  mydataX <- mydata
  mydataX$Year=i
  full_data <- bind_rows(full_data, mydataX)
}
file_list[[5]] <- full_data

#file_list[[6]] <- read_csv("/srv/scratch/z3374139/Lionfish/2017/Shallow_end_points.csv")
#file_list[[6]] <- read_csv("Output/Katana/All Shallow/2017_Shallow_end_points.csv") %>%
file_list[[6]] <- read_csv("/srv/scratch/z3374139/Lionfish/2017_Shallow_end_points.csv") %>%
  dplyr::select(lat, lon)

mydata <- file_list[[6]]
#head(mydata)
mydata$Year <- 2018
full_data <- mydata
for (i in 2019:2020){
  mydataX <- mydata
  mydataX$Year=i
  full_data <- bind_rows(full_data, mydataX)
}
file_list[[6]] <- full_data

#file_list[[7]] <- read_csv("/srv/scratch/z3374139/Lionfish/2018/Shallow_end_points.csv")
#file_list[[7]] <- read_csv("Output/Katana/All Shallow/2018_Shallow_end_points.csv") %>%
file_list[[7]] <- read_csv("/srv/scratch/z3374139/Lionfish/2018_Shallow_end_points.csv") %>%
  dplyr::select(lat, lon)

mydata <- file_list[[7]]
#head(mydata)
mydata$Year <- 2019
full_data <- mydata
for (i in 2020:2020){
  mydataX <- mydata
  mydataX$Year=i
  full_data <- bind_rows(full_data, mydataX)
}
file_list[[7]] <- full_data

#file_list[[8]] <- read_csv("/srv/scratch/z3374139/Lionfish/2019/Shallow_end_points.csv")
#file_list[[8]] <- read_csv("Output/Katana/All Shallow/2019_Shallow_end_points.csv") %>%
file_list[[8]] <- read_csv("/srv/scratch/z3374139/Lionfish/2019_Shallow_end_points.csv") %>%
  dplyr::select(lat, lon)

file_list[[8]]$Year <- 2020

# table(full_data$Year)

mydata <- NULL
mydataX <- NULL

full_dat <- bind_rows(file_list)

start_dat <- data.frame(lat= 34.490556, lon = 35.7, Year = 2012)

full_dat <- bind_rows(full_dat, start_dat)

#head(full_dat)
#full_dat

#full_dat$Date <- as.Date(full_dat$Date)
#full_dat$Year <- lubridate::year((full_dat$Date-26))+1

world <- ne_countries(scale = "large", returnclass = "sf")
class(world)

map_ <- ggplot(full_dat) +
  geom_point(data = full_dat, aes(x = lon, y = lat), size = 1, alpha=0.1,
             shape = 21, fill = "blue") +
  geom_sf(data = world, col="grey70", fill = "grey70")+ facet_wrap(~Year)+
  coord_sf(xlim = c(5, 38), ylim = c(30, 43), expand = FALSE) +
  theme_bw() + xlab("Longitude (°)") + ylab("Latitude (°)")+
  #stat_density2d(mapping= aes(alpha = ..level.. , x = lon, y = lat), geom="polygon", bins=6, size=1)+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))+
  theme(axis.text = element_text(colour = "black"))

map_

ggsave("Plots/Final Test_Hindcast.png", dpi = 600, height = 21, width = 29.5, units = "cm")
ggsave("Plots/Final Test_Hindcast.pdf", dpi = 600, height = 21, width = 29.5, units = "cm")

## Full end points

file_list <- list()
file_list[[1]] <- read_csv("/srv/scratch/z3374139/Lionfish/2012/2012_end_points_reduced.csv")
file_list[[2]] <- read_csv("/srv/scratch/z3374139/Lionfish/2013/Full_end_points.csv")
file_list[[3]] <- read_csv("/srv/scratch/z3374139/Lionfish/2014/Full_end_points.csv")
file_list[[4]] <- read_csv("/srv/scratch/z3374139/Lionfish/2015/Full_end_points.csv")
file_list[[5]] <- read_csv("/srv/scratch/z3374139/Lionfish/2016/Full_end_points.csv")
file_list[[6]] <- read_csv("/srv/scratch/z3374139/Lionfish/2017/Full_end_points.csv")
file_list[[7]] <- read_csv("/srv/scratch/z3374139/Lionfish/2018/Full_end_points.csv")
file_list[[8]] <- read_csv("/srv/scratch/z3374139/Lionfish/2019/Full_end_points.csv")




file_list[[1]]$Year <- 2013
file_list[[2]]$Year <- 2014
file_list[[3]]$Year <- 2015
file_list[[4]]$Year <- 2016
file_list[[5]]$Year <- 2017
file_list[[6]]$Year <- 2018
file_list[[7]]$Year <- 2019
file_list[[8]]$Year <- 2020


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
  coord_sf(xlim = c(5, 38), ylim = c(30, 43), expand = FALSE) +
  theme_bw() +
  #stat_density2d(mapping= aes(alpha = ..level.. , x = lon, y = lat), geom="polygon", bins=6, size=1)+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

map_

ggsave("Final Test full points_Hindcast.png", dpi = 600, height = 21, width = 29.5, units = "cm")