# test dodgy subseting

library(tidyverse)

mydata <- read_csv("E:/Lionfish/2018/Shallow_end_points.csv")

head(mydata)

mydata2 <- mydata %>% slice_min(lon, n=1000)
write_csv(mydata2, "2018_different_starts.csv")
