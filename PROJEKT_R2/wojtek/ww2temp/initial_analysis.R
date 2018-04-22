# raw data https://www.kaggle.com/smid80/weatherww2/data
# https://www.ncdc.noaa.gov/data-access/land-based-station-data/land-based-datasets/world-war-ii-era-data
# ftp://ftp.ncdc.noaa.gov/pub/data/ww-ii-data/map.gif

library(tidyverse)

df_stations <- read.csv("data/Weather Station Locations.csv")
head(df_stations,5)

install.packages("rworldmap")
library(rworldmap)

#create map of locations along witch charts

#some weather stations are repeated, checking that
nt <- table(df_stations$NAME)
nt[nt>1]
df_stations[df_stations$NAME == "BASTIA/CORSICA" | df_stations$NAME == "SAN JOSE",]
#ok it is not an error - stations do not duplicate


df_weather <-  read.csv("data/Summary of Weather.csv")
head(df_weather,5)

#general view to all min  max relatonsips
ggplot(df_weather,aes(x = MinTemp, y = MaxTemp, col = STA)) + geom_point()

df_all <- merge(x = df_weather, y = df_stations, by.x = "STA", by.y = "WBAN", all = TRUE)
