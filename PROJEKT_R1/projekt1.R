library(XML)
library(RCurl)
library(tidyr)
#install.packages("tidyr")

link = "https://docs.google.com/spreadsheets/d/1P9PG5mcbaIeuO9v_VE5pv6U4T2zyiRiFK_r8jVksTyk/htmlembed?single=true&gid=0&range=a10:o400&widget=false&chrome=false"
xData <- getURL(link)
raw_data <- readHTMLTable(xData,header = TRUE, skip.rows = c(1,3), stringsAsFactors = FALSE,encoding = "utf8")
df_dane <- raw_data[[1]]
head(df_dane)

for (i in 8:16)
  df_dane[[i]] <- as.numeric(gsub(",",".",df_dane[[i]]))
  

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



