# Map of lionfish sightings
# World map
library(tidyverse)
library("rnaturalearth")
library("rnaturalearthdata")



world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

# 1 row per study
#mydata2 <- mydata %>% distinct(`Reference Number`, .keep_all = TRUE)
mydata <- read.csv("Lionfish sightings Dimitriadis et al. 2020.csv")

P_map <- ggplot(mydata) +
  geom_sf(data = world, col="grey70", fill = "grey70")+ facet_wrap(~Year)+
  coord_sf(xlim = c(10, 38), ylim = c(30, 43), expand = FALSE) +
  geom_point(data = mydata, aes(x = Y, y = X), size = 1.5, alpha=0.5,
             shape = 21, fill = "blue") +
  #geom_text_repel(data = mydata2, aes(x = Longitude, y = Latitude, label = `Reference Number`),col="black", size =3.5, fontface = "bold") +
  theme_bw() +
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0))

P_map

ggsave("Output/Observation Map.png", dpi = 600, units = "cm", height = 21, width=14.8*2)


