# Map of lionfish sightings
# World map
library(tidyverse)
library("rnaturalearth")
library("rnaturalearthdata")



world <- ne_countries(scale = "large", returnclass = "sf")
class(world)

# 1 row per study
#mydata2 <- mydata %>% distinct(`Reference Number`, .keep_all = TRUE)
mydata <- read.csv("Copy of Supplementary Material 2 - Dataset of lionfish sightings.csv")
mydata <- mydata %>% filter(Year>2008)
mydata <- mydata %>% rownames_to_column(var = "ID")

### need to make the plotting cumulative


P_map <- ggplot(mydata) +
  geom_sf(data = world, col="grey70", fill = "grey70")+ facet_wrap(~Year)+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  geom_point(data = mydata, aes(x = X...Longitude, y = Y...Latidue), size = 1.5, alpha=0.5,
             shape = 21, fill = "blue") +
  #geom_text_repel(data = mydata2, aes(x = Longitude, y = Latitude, label = `Reference Number`),col="black", size =3.5, fontface = "bold") +
  theme_bw() + xlab("Longitude (°)") + ylab("Latitude (°)")+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

P_map

### now stack to make cummulative

mydata2 <- mydata %>% filter(Year ==2012)
head(mydata2)
#mydata$Year <- 2013
new_data_2012 <- mydata2
for (i in 2013:2020){
  mydataX <- mydata2
  mydataX$Year=i
  new_data_2012 <- bind_rows(new_data_2012, mydataX)
}

mydata2 <- mydata %>% filter(Year ==2013)
head(mydata2)
#mydata$Year <- 2013
new_data_2013 <- mydata2
for (i in 2014:2020){
  mydataX <- mydata2
  mydataX$Year=i
  new_data_2013 <- bind_rows(new_data_2013, mydataX)
}

mydata2 <- mydata %>% filter(Year ==2014)
head(mydata2)
#mydata$Year <- 2013
new_data_2014 <- mydata2
for (i in 2015:2020){
  mydataX <- mydata2
  mydataX$Year=i
  new_data_2014 <- bind_rows(new_data_2014, mydataX)
}

mydata2 <- mydata %>% filter(Year ==2015)
head(mydata2)
#mydata$Year <- 2013
new_data_2015 <- mydata2
for (i in 2016:2020){
  mydataX <- mydata2
  mydataX$Year=i
  new_data_2015 <- bind_rows(new_data_2015, mydataX)
}

mydata2 <- mydata %>% filter(Year ==2016)
head(mydata2)
#mydata$Year <- 2013
new_data_2016 <- mydata2
for (i in 2017:2020){
  mydataX <- mydata2
  mydataX$Year=i
  new_data_2016 <- bind_rows(new_data_2016, mydataX)
}

mydata2 <- mydata %>% filter(Year ==2017)
head(mydata2)
#mydata$Year <- 2013
new_data_2017 <- mydata2
for (i in 2018:2020){
  mydataX <- mydata2
  mydataX$Year=i
  new_data_2017 <- bind_rows(new_data_2017, mydataX)
}

mydata2 <- mydata %>% filter(Year ==2018)
head(mydata2)
#mydata$Year <- 2013
new_data_2018 <- mydata2
for (i in 2019:2020){
  mydataX <- mydata2
  mydataX$Year=i
  new_data_2018 <- bind_rows(new_data_2018, mydataX)
}

mydata2 <- mydata %>% filter(Year ==2019)
head(mydata2)
#mydata$Year <- 2013
new_data_2019 <- mydata2
for (i in 2020:2020){
  mydataX <- mydata2
  mydataX$Year=i
  new_data_2019 <- bind_rows(new_data_2019, mydataX)
}

mydata2 <- mydata %>% filter(Year ==2020)
head(mydata2)
#mydata$Year <- 2013
new_data_2020 <- mydata2

new_full_data <- bind_rows(new_data_2012, new_data_2013, new_data_2014, new_data_2015, new_data_2016, 
                           new_data_2017, new_data_2018, new_data_2019, new_data_2020)

head(new_full_data)

P_map <- ggplot(new_full_data) +
  geom_sf(data = world, col="grey70", fill = "grey70")+ facet_wrap(~Year)+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  geom_point(data = new_full_data, aes(x = X...Longitude, y = Y...Latidue), size = 1.5, alpha=0.6,
             shape = 21, fill = "blue") +
  #geom_text_repel(data = mydata2, aes(x = Longitude, y = Latitude, label = `Reference Number`),col="black", size =3.5, fontface = "bold") +
  theme_bw() + xlab("Longitude (°)") + ylab("Latitude (°)")+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0)) +
  theme(axis.text = element_text(colour="black"))

P_map

ggsave("Plots/Observation Map.png", dpi = 600, units = "cm", height = 14.8, width=21)
ggsave("Plots/Observation Map.pdf", dpi = 600, units = "cm", height = 14.8, width=21)


library(gganimate)
library(gifski)
#install.packages("gifski")
P_anim <- ggplot(mydata) +
  geom_sf(data = world, col="grey70", fill = "grey70")+ transition_states(Year)+ shadow_mark()+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  geom_point(data = mydata, aes(x = X...Longitude, y = Y...Latidue, group=ID), size = 1.5, alpha=0.5,
             shape = 21, fill = "blue") +
  #geom_text_repel(data = mydata2, aes(x = Longitude, y = Latitude, label = `Reference Number`),col="black", size =3.5, fontface = "bold") +
  theme_bw() + xlab("Longitude (°)") + ylab("Latitude (°)")+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0)) +
  theme(axis.text = element_text(colour="black")) +
  labs(title = 'Year: {closest_state}')



animate(P_anim, duration = 5, fps = 20, renderer = gifski_renderer())
#anim_save("output.gif")
anim_save("mapanim.gif", P_anim, renderer = gifski_renderer())





#### Plotting from simulations
file_list <- list.files("Output/Katana/Reduced/", pattern=".csv", recursive = T, full.names = T)

files_together <- list()
for (i in (1:length(file_list))){
  files_together[[i]] <- read_csv(file_list[i])
}

full_dat <- bind_rows(files_together)
full_dat <- full_dat %>% rownames_to_column(var = "ID")
full_dat$Year <- full_dat$Year+1

P_anim_sim <- ggplot(full_dat) +
  geom_sf(data = world, col="grey70", fill = "grey70")+ transition_states(Year)+# shadow_mark()+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +#
  geom_point(data = full_dat, aes(x = lon, y = lat, group=ID), size = 1.5, alpha=0.5,
             shape = 21, fill = "blue") +
  #geom_text_repel(data = mydata2, aes(x = Longitude, y = Latitude, label = `Reference Number`),col="black", size =3.5, fontface = "bold") +
  theme_bw() + xlab("Longitude (°)") + ylab("Latitude (°)")+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0)) +
  theme(axis.text = element_text(colour="black")) +
  labs(title = 'Year: {closest_state}')



animate(P_anim_sim, duration = 5, fps = 20, renderer = gifski_renderer())
#anim_save("output.gif")
anim_save("mapanim_simulation.gif", P_anim_sim, renderer = gifski_renderer())



### Test new 2019 output

# Map of lionfish sightings
# World map
library(tidyverse)
library("rnaturalearth")
library("rnaturalearthdata")



world <- ne_countries(scale = "large", returnclass = "sf")
class(world)

# 1 row per study
#mydata2 <- mydata %>% distinct(`Reference Number`, .keep_all = TRUE)
mydata <- read_csv("New directory/Shallow_end_points_FINAL.csv")
#mydata <- mydata %>% filter(Year>2008)
#mydata <- mydata %>% rownames_to_column(var = "ID")

### need to make the plotting cumulative


P_map <- ggplot(mydata) +
  geom_sf(data = world, col="grey70", fill = "grey70")+ facet_wrap(~Year)+
  coord_sf(xlim = c(0, 38), ylim = c(30, 43), expand = FALSE) +
  geom_point(data = mydata, aes(x = lon, y = lat), size = 1.5, alpha=0.5,
             shape = 21, fill = "blue") +
  #geom_text_repel(data = mydata2, aes(x = Longitude, y = Latitude, label = `Reference Number`),col="black", size =3.5, fontface = "bold") +
  theme_bw() + xlab("Longitude (°)") + ylab("Latitude (°)")+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

P_map

ggsave("Output/Observation Map test.png", dpi = 600, units = "cm", height = 21, width=14.8*2)

