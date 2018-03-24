library(XML)
library(RCurl)
library(tidyr)
#install.packages("tidyr")

link = "https://docs.google.com/spreadsheets/d/1P9PG5mcbaIeuO9v_VE5pv6U4T2zyiRiFK_r8jVksTyk/htmlembed?single=true&gid=0&range=a10:o400&widget=false&chrome=false"
xData <- getURL(link)
raw_data <- readHTMLTable(xData,header = TRUE,  stringsAsFactors = FALSE,encoding = "utf8")

tab <- raw_data[[1]]

#as.numeric(gsub(",",".","12,34"))

hdr_names <- c("lp","Osrodek","Zleceniodawca","Publikacja","Metoda badania",
               "uwzgl niezdecyd.","termin badania","PiS",
               "PO","K15","SLD",".N","PSL","Partia razem","Wolnosc","N/Z")

tab<- tab[4:236,]
colnames(tab)<-hdr_names

for (i in 8:16)
  tab[[i]] <- as.numeric(gsub(",",".",tab[[i]]))
  

ggplot(data = tab) + 
  geom_point(mapping = aes(
    x = as.Date(tab$Publikacja,"%d.%m.%y"),
    y = tab$.N,
    color = tab$Osrodek)) +
   geom_smooth(mapping = aes(
    x = as.Date(tab$Publikacja,"%d.%m.%y"),
    y = tab$.N,
    color = tab$Osrodek))



