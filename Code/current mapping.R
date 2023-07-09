# Mean currents

library(tidyverse)
library(tidync)

mydat <- tidync("Data/Med_29m_2012.nc")
mydat_long <- hyper_tibble(mydat)
head(mydat_long)
mydata <- ncdf4::nc_open("Data/Med_29m_2013_2014.nc")
#mydata <- ncdf4::nc_open("Output/2013/2013_after_main_spawning_19.nc")
#print(mydata)
time_origin <- mydata$var$vomecrty$dim[[4]]$units 

#  time$units
time_origin2 <- stringr::str_sub(time_origin, 15, 24) # not working
time_origin3 <- stringr::str_sub(time_origin, 26, 33)
time_origin <- paste(time_origin2, " ", time_origin3)
time_origin
ncdf4::nc_close(mydata)


mydat_long$Date <- as.POSIXct(mydat_long$time, origin = time_origin)
mydat_long$Date <- as.Date(mydat_long$Date)
mydat_long$Month <- lubridate::month(mydat_long$Date)

head(mydat_long)

mydat_long <- mydat_long %>% filter(Month>=5 & Month <= 7)

mydat_long2 <- mydat_long %>% group_by(lon, lat) %>% summarise(Xv = mean(vozocrtx, na.rm = T), Yv = mean(vomecrty, na.rm = T))
head(mydat_long2)

library("rnaturalearth")
library("rnaturalearthdata")


world <- ne_countries(scale = "large", returnclass = "sf")
class(world)

#install.packages("metR")
library(metR)

P_map <- ggplot(mydat_long2) +
  geom_sf(data = world, col="grey70", fill = "grey70")+ #facet_wrap(~Year)+
  coord_sf(xlim = c(0, 37), ylim = c(30, 43), expand = FALSE) +
  geom_vector(aes(x=lon, y=lat, dx=Xv, dy=Yv), skip=6, colour="black")+
  geom_point(aes(x=35.7, y = 34.490556), col="red")+
  #geom_point(data = mydata, aes(x = lon, y = lat), size = 1.5, alpha=0.5,
             #shape = 21, fill = "blue") +
  #geom_text_repel(data = mydata2, aes(x = Longitude, y = Latitude, label = `Reference Number`),col="black", size =3.5, fontface = "bold") +
  theme_bw() + xlab("Longitude (°)") + ylab("Latitude (°)")+
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))+
  theme(axis.text = element_text(colour = "black"),
        legend.position = c(0.125,0.15),
        legend.background = element_rect(fill="grey70"),
        legend.key = element_rect(fill="grey70")) +
  scale_mag(name="Mean Current\nSpeed (m/s)", max=0.5, labels = c("0.5"))

P_map

ggsave("Plots/Mean currents.png", units="cm", height=10.8, width = 21, dpi = 600)
ggsave("Plots/Mean currents.pdf", units="cm", height=10.8, width = 21, dpi = 600)
