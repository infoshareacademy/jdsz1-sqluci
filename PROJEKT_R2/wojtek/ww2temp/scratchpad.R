library(tidyverse)
library(ggmap)
library(maps)
library(mapdata)

df_stations <- read.csv("data/Weather Station Locations.csv")
head(df_stations,3)

nt <- table(df_stations$NAME)
nt[nt>1]
df_stations[df_stations$NAME == "BASTIA/CORSICA" | df_stations$NAME == "SAN JOSE",]

wrld <- map_data("world")
ggplot() + geom_polygon(data = wrld, aes(x=long, y = lat, group = group)) +
  geom_point(data = df_stations, aes(x = Longitude, y = Latitude, col = STATE.COUNTRY.ID)) +  
  geom_text(data = df_stations, aes(x = Longitude, y = Latitude, col = STATE.COUNTRY.ID,label=STATE.COUNTRY.ID),hjust=0, vjust=0) + 
  scale_fill_discrete(guide=FALSE) + scale_color_discrete(guide = FALSE)

df_weather <-  read.csv("data/Summary of Weather.csv")

any(is.na(df_weather$MinTemp))
any(is.na(df_weather$MaxTemp))


head(df_weather,3)
df_weather$STA <- as.factor(df_weather$STA) #Set weather station as factor

ggplot(df_weather,aes(x = MinTemp, y = MaxTemp, col = STA)) + 
  geom_point() + scale_colour_discrete(guide = FALSE)

df_all <- merge(x = df_weather, y = df_stations, by.x = "STA", by.y = "WBAN")

ggplot(df_all,aes(x = MinTemp, y = MaxTemp, col = STATE.COUNTRY.ID)) + 
  geom_point() 

df_all <- df_all[df_all$MinTemp < df_all$MaxTemp & !(df_all$MaxTemp > 11 & df_all$MinTemp > -20 & df_all$MinTemp < -10),]

ggplot(df_all,aes(x = MinTemp, y = MaxTemp, col = STATE.COUNTRY.ID)) + 
  geom_point() #+ geom_text(aes(col = STATE.COUNTRY.ID,label=STATE.COUNTRY.ID),hjust=0, vjust=0)


ggplot(df_all,aes(x = MinTemp, y = MaxTemp, col = STATE.COUNTRY.ID)) +
  geom_point(show.legend = FALSE) + facet_wrap(~STATE.COUNTRY.ID,scales="free")


u_state_ID <-  unique(df_all$STATE.COUNTRY.ID)
cor_coef <- rep(NA,length(u_state_ID))

meanMinTemp <- rep(NA,length(u_state_ID))
meanMaxTemp <- rep(NA,length(u_state_ID))

i <- 0 
for (id in u_state_ID)
{
  i<-i+1
  mmT <- df_all[df_all$STATE.COUNTRY.ID == id,c("MinTemp","MaxTemp")]
  cor_coef[i] <- cor(mmT$MinTemp,mmT$MaxTemp)
  
  meanMinTemp[i] = mean(mmT$MinTemp)
  meanMaxTemp[i] = mean(mmT$MaxTemp)
}

cor(df_all[,c("MinTemp","MaxTemp")]) # global correlation coefficient seems fine
lin_model_global <- lm(MaxTemp ~ MinTemp,data = df_all)

ggplot(df_all,aes(x = MinTemp, y = MaxTemp, col = STATE.COUNTRY.ID)) + 
  geom_point() + geom_smooth(method='lm',formula=y~x)

ggplot(df_all,aes(x = MinTemp, y = MaxTemp)) + 
  geom_point() + geom_smooth(method='lm',formula=y~x)

#choosing low correlated subsets and pltting them

corr_ceof


cor(meanMinTemp,meanMaxTemp)
ggplot(data.frame(meanMinTemp,meanMaxTemp),aes(x =meanMinTemp, y = meanMaxTemp)) + 
  geom_point() 

ggplot() + 
  geom_point(data = df_all,aes(x = MinTemp, y = MaxTemp, col = 'blue')) +
  geom_point(data = data.frame(meanMinTemp,meanMaxTemp),aes(x =meanMinTemp, y = meanMaxTemp))


//podzielić względem max różnicy w ciągu doby