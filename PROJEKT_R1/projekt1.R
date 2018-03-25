library(XML)
library(RCurl)
library(tidyr)
#install.packages("tidyr")

link <- "https://docs.google.com/spreadsheets/d/1P9PG5mcbaIeuO9v_VE5pv6U4T2zyiRiFK_r8jVksTyk/htmlembed?single=true&gid=0&range=a10:o400&widget=false&chrome=false" 
xData <- getURL(link)  #get link
dane_z_html <- readHTMLTable(xData, stringsAsFactors = FALSE, skip.rows = c(1,3), encoding = "utf8") #read html
df_dane <- as.data.frame(dane_z_html)   #data frame
colnames(df_dane) <- df_dane[1,]  #nazwy kolumn
df2 <- df_dane[2:nrow(df_dane),]  #pominięcie pierwszego wiersza
for (i in 8:16)
  df2[[i]] <- as.numeric(gsub(",",".",df2[[i]]))      #przecinki
df2


#wojtek
ggplot(data = tab) + 
  geom_point(mapping = aes(
    x = as.Date(tab$Publikacja,"%d.%m.%y"),
    y = tab$.N,
    color = tab$Osrodek)) +
   geom_smooth(mapping = aes(
    x = as.Date(tab$Publikacja,"%d.%m.%y"),
    y = tab$.N,
    color = tab$Osrodek))



