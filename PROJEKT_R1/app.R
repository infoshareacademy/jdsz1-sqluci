#install.packages("dplyr")
#install_github("rstudio/shiny")  #instal shiny
#install.packages("shiny")
#install.packages("shinydashboard")
#install.packages("wordcloud")
#install.packages("syuzhet")
#install.packages("tidyverse")
#install.packages("tm")
#install.packages("SnowballC")

library(devtools)
library(shiny)
library(shinydashboard)
library(RPostgreSQL)
library(plyr)
library(dplyr)
library(scales)
library(wordcloud)
library(syuzhet)
library(tidyverse)
library(XML)
library(RCurl)
library(tidyr)
library(tm)
library(SnowballC)

ui <- dashboardPage(
  # HEADER
  ################################################################################################
  dashboardHeader(title = "Analiza sondazy wyborczych"
                  #,dropdownMenu(type = "tasks",
                  #             taskItem("ABC")
                  #             )
                  ),
  # SIDEBAR
  ################################################################################################
  dashboardSidebar(
    sidebarMenu(
      menuItem("Partie polityczne (DEV)", tabName = "tab_partie", icon = icon("th")),
      
      menuItem("Wyniki", tabName = "tab_wyniki_ogolne", icon = icon("dashboard"),  badgeColor = "green",
               menuSubItem("Wyniki ogolnie", tabName = "tab_wyniki_ogolne", icon = icon("th")),
               menuSubItem("Wyniki szczegolowe", tabName = "tab_wyniki_szczegolowe", icon = icon("th"))
               ),
      
      menuItem("Text mining (DEV)", tabName = "tab_text_mining", icon = icon("th"),
               menuSubItem("Czestosc slow", tabName = "tab_text_mining_czestosc_slow", icon = icon("th")),
               menuSubItem("Chmura slow", tabName = "tab_text_mining_chmura_slow", icon = icon("th")),
               menuSubItem("Find freq terms", tabName = "tab_text_mining_czestosci", icon = icon("th")),
               menuSubItem("Asocjacje", tabName = "tab_text_mining_asocjacje", icon = icon("th")),
               menuSubItem("Emocje", tabName = "tab_text_mining_emocje", icon = icon("th")),
               menuSubItem("Sentyment", tabName = "tab_text_mining_sentyment", icon = icon("th"))
               ),
      
      menuItem("Tworcy", tabName = "tab_creators", icon = icon("th"),
               menuSubItem("Monika Serkowska", tabName = "tab_creators_ms", icon = icon("th")),
               menuSubItem("Magdalena Kortas", tabName = "tab_creators_mk", icon = icon("th")),
               menuSubItem("Wojciech Artichowicz", tabName = "tab_creators_wa", icon = icon("th"))
      )      
      
    )
  ),
  
  # BODY
  ################################################################################################
  dashboardBody(
    tabItems(
      # Partie
      ################################################################################################
      tabItem(tabName = "tab_partie",
              fluidRow(
                h2("Analiza partii politycznych")
              ),
              fluidRow(
                plotOutput("wykresy")
              )
      ),
      
      # Wyniki
      ################################################################################################
      #ogolne
      tabItem(tabName = "tab_wyniki_ogolne",
              fluidRow(
                h2("Uogolnione wyniki sondazy wyborczych")
              ),
              fluidRow(
                column(width = 10,
                       dataTableOutput("results")
                )
              )              
      ),
      
      tabItem(tabName = "tab_wyniki_szczegolowe",
              fluidRow(

                radioButtons("in_rb_partie", label = h3("Partia polityczna"),
                             choices = list("A","B"),
                             inline = TRUE
                      ),
              fluidRow(plotOutput("plot_partie"))

            )
      ),      
      # Text mining
      ################################################################################################
      tabItem(tabName = "tab_text_mining",
              fluidRow(
                h2("Text mining ogolna")
              )
      ), 
      tabItem(tabName = "tab_text_mining_czestosc_slow",
              fluidRow(
                h2("Text mining :: czestosc slow")
              ),
              fluidRow(
                column(width = 6, plotOutput("word_freq_magda")
                )
              )              
      ), 
      tabItem(tabName = "tab_text_mining_chmura_slow",
              fluidRow(
                h2("Text mining :: chmura slow")
              )
      ),      
      tabItem(tabName = "tab_text_mining_czestosci",
              fluidRow(
                h2("Text mining :: czestosci (?)")
              )
      ), 
      tabItem(tabName = "tab_text_mining_asocjacje",
              fluidRow(
                h2("Text mining :: asocjacje")
              )
      ),   
      tabItem(tabName = "tab_text_mining_emocje",
              fluidRow(
                h2("Text mining :: emocje")
              )
      ),  
      tabItem(tabName = "tab_text_mining_sentyment",
              fluidRow(
                h2("Text mining :: sentyment")
              )
      ),
      
      # Credits
      ################################################################################################
      tabItem(tabName = "tab_creators", fluidRow(h2("Tworcy") ),
              menuSubItem("Monika Serkowska", tabName = "tab_creators_ms", icon = icon("th")),
              menuSubItem("Magdalena Kortas", tabName = "tab_creators_mk", icon = icon("th")),
              menuSubItem("Wojciech Artichowicz", tabName = "tab_creators_wa", icon = icon("th"))
              )      
    )
  )
)



bool_app_init <- TRUE

server <- function(input, output,session) {

  if (bool_app_init){
    print("init - loading data")
    
      bool_app_init<-FALSE
      
      link <- "https://docs.google.com/spreadsheets/d/1P9PG5mcbaIeuO9v_VE5pv6U4T2zyiRiFK_r8jVksTyk/htmlembed?single=true&gid=0&range=a10:o400&widget=false&chrome=false" 
      xData <- getURL(link)  #get link
      dane_z_html <- readHTMLTable(xData, stringsAsFactors = FALSE, skip.rows = c(1,3), encoding = "utf8") #read html
      df_dane <- as.data.frame(dane_z_html)   #data frame
      colnames(df_dane) <- df_dane[1,]  #nazwy kolumn
      df2 <- df_dane[2:nrow(df_dane),]  
      rm(df_dane)
      rm(dane_z_html)
      rm(xData)
      for (i in 8:16)
         df2[[i]] <- as.numeric(gsub(",",".",df2[[i]]))      # remove commas
     colnames(df2)[2]<- "Osrodek"  
  }
     
     observe({
       # Can also set the label and select items
       updateRadioButtons(session, "in_rb_partie",
                          choices = as.list(colnames(df2)[8:16] ),
                          inline = TRUE
       )
     })     
     
     
     output$plot_partie <- renderPlot({
       ggplot(data = df2) + 
         geom_point(mapping = aes(
           x = as.Date(Publikacja,"%d.%m.%y"),
           y = .N,
           color = Osrodek)
         ) +
         geom_smooth(mapping = aes(
           x = as.Date(Publikacja,"%d.%m.%y"),
           y = .N,
           color = Osrodek))       
     })
     
     
     output$results <-renderDataTable(df2)
     
     output$word_freq_magda <- renderPlot({
       word_freq_magda() 
     }, bg="transparent")
}




word_freq_magda <- function() {
  
  library(tm)
  library(SnowballC)
  library(wordcloud)
  library(RColorBrewer)
  library(tidyverse)
  
  
  
  filePath <- paste(getwd(),"parties_en.txt",sep = "/")
  text <- read_lines(filePath)
  docs <- Corpus(VectorSource(text))
  
  docs <- tm_map(docs, tolower) #mniejszy rozmiar
  docs <- tm_map(docs, removeNumbers) #numerki
  docs <- tm_map(docs, removeWords, stopwords("english")) #usuwanie
  docs <- tm_map(docs, removePunctuation) #punktuacja
  docs <- tm_map(docs, stripWhitespace) #
  
  docs2 <-tm_map(docs, stemDocument)   #
  dtm <- TermDocumentMatrix(docs2)      #
  m   <- as.matrix(dtm)                   #na 
  v   <- sort(rowSums(m), decreasing=TRUE)   #sortow
  d   <- data.frame(word=names(v), freq=v)  #now
  
  # bar chart
  return(ggplot(data = head(d,50), mapping = aes(x = reorder(word, freq), y = freq)) +
    geom_bar(stat = "identity") +
    xlab("Word") +
    ylab("Word frequency") +
    coord_flip())
}


shinyApp(ui, server)
