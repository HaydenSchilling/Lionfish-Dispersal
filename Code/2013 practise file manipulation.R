# Merge parcels outputs

# load my results
library(tidyverse)
library(tidync)


#world <- ne_countries(scale = "large", returnclass = "sf")
#class(world)

full_dat <- data.frame()

file_list <- list.files(path = "Output/2013/", pattern = ".nc", full.names = TRUE)

for (i in 1:length(file_list)){
datX <- hyper_tibble(tidync(file_list[i]))
full_dat <- bind_rows(full_dat, datX)
}

full_dat$age <- full_dat$age/86400

write_csv(full_dat, "Output/2013/Full_paths.csv")

full_dat <- full_dat %>% filter(age == 26)

write_csv(full_dat, "Output/2013/Full_end_points.csv")

full_dat <- full_dat %>% filter(bathy <= 350)

write_csv(full_dat, "Output/2013/Shallow_end_points.csv")

full_dat <- full_dat %>% sample_n(size=1000, replace = F)

write_csv(full_dat, "Output/2013/Shallow_end_points_reduced.csv")

