#install.packages("dplyr")
#install_github("rstudio/shiny")  #instal shiny
#install.packages("shiny")
#install.packages("shinydashboard")
#install.packages("wordcloud")
#install.packages("syuzhet")
#install.packages("tidyverse")
#install.packages("tm")
#install.packages("SnowballC")
#install.packages("XML")
#install.packages("RCurl")
#install.packages("tm")
#install.packages("SnowballC")
#install.packages("RColorBrewer")

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
library(tm)
library(SnowballC)
library(RColorBrewer)

# locale test  ąćł

ui <- dashboardPage(
  # HEADER
  ################################################################################################
  dashboardHeader(title = "Political parties polls"
                  #,dropdownMenu(type = "tasks",
                  #             taskItem("ABC")
                  #             )
                  ),
  # SIDEBAR
  ################################################################################################
  dashboardSidebar(
    sidebarMenu(
      menuItem("Political parties (DEV)", tabName = "tab_partie", icon = icon("th")),
      
      menuItem("Results", tabName = "tab_wyniki_ogolne", icon = icon("dashboard"),  badgeColor = "green",
               menuSubItem("General results", tabName = "tab_wyniki_ogolne", icon = icon("th")),
               menuSubItem("Detailed results", tabName = "tab_wyniki_szczegolowe", icon = icon("th"))
               ),
      
      menuItem("Text mining (DEV)", tabName = "tab_text_mining", icon = icon("th"),
               menuSubItem("Word frequency", tabName = "tab_text_mining_czestosc_slow", icon = icon("th")),
               menuSubItem("Word cloud", tabName = "tab_text_mining_chmura_slow", icon = icon("th")),
               menuSubItem("Frequent terms", tabName = "tab_text_mining_czestosci", icon = icon("th")),
               menuSubItem("Associations", tabName = "tab_text_mining_asocjacje", icon = icon("th")),
               menuSubItem("Emotions", tabName = "tab_text_mining_emocje", icon = icon("th")),
               menuSubItem("Sentiment", tabName = "tab_text_mining_sentyment", icon = icon("th"))
               ),
      
      menuItem("Creators", tabName = "tab_creators", icon = icon("th"),
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
                h2("Political parties")
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
                h2("General view to polls")
              ),
              fluidRow(
                column(width = 10,
                       dataTableOutput("results")
                )
              )              
      ),
      
      tabItem(tabName = "tab_wyniki_szczegolowe",
              fluidRow(
                radioButtons("in_rb_partie", label = h3("Political party"),
                             choices = list("A","B"),
                             inline = TRUE
                      ),
              fluidRow(plotOutput("plot_partie"))
            ),
            fluidRow(h3("Test"),
                     bootstrapPage(
                       div(style="display:inline-block",selectInput("in_si_osrodek", "Osrodek:",c("A","B"))), 
                       div(style="display:inline-block",selectInput("in_si_zamawiajacy", "Zamawiajacy:",c("A","B")))),
                     dataTableOutput("dt_extended_table"))
      ),      
      # Text mining
      ################################################################################################
      tabItem(tabName = "tab_text_mining",
              fluidRow(
                h2("Text mining")
              )
      ), 
      tabItem(tabName = "tab_text_mining_czestosc_slow",
              fluidRow(
                h2("Word frequency")
              ),
              fluidRow(
                column(width = 6, plotOutput("word_freq_magda")
                )
              )              
      ), 
      tabItem(tabName = "tab_text_mining_chmura_slow",
              fluidRow(
                h2("Word cloud")
              )
      ),      
      tabItem(tabName = "tab_text_mining_czestosci",
              fluidRow(
                h2("Word frequency analysis")
              )
      ), 
      tabItem(tabName = "tab_text_mining_asocjacje",
              fluidRow(
                h2("Associations")
              )
      ),   
      tabItem(tabName = "tab_text_mining_emocje",
              fluidRow(
                h2("Emotions")
              )
      ),  
      tabItem(tabName = "tab_text_mining_sentyment",
              fluidRow(
                h2("Sentiment")
              )
      ),
      
      # Credits
      ################################################################################################
      tabItem(tabName = "tab_creators", fluidRow(h2("Creators") ),
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
     colnames(df2)[2] <- "Osrodek"  
     colnames(df2)[15] <- "WOLNOSC"

     
     observe({
       # Can also set the label and select items
       updateRadioButtons(session, "in_rb_partie",
                          choices = as.list(colnames(df2)[8:16] ),
                          inline = TRUE,
                          selected = ".N"
                          )
       updateSelectInput(session, "in_si_osrodek",choices = unique(df2$Osrodek))
       updateSelectInput(session, "in_si_zamawiajacy",choices = unique(df2$Zleceniodawca))
       
     })     
  }
     # Wojtek ##################################################################################
     output$plot_partie <- renderPlot({
       ggplot(data = df2) + 
         geom_point(mapping = aes(
           x = as.Date(Publikacja,"%d.%m.%Y"),
           y = df2[input$in_rb_partie],
           color = Osrodek)
         ) +
         geom_smooth(mapping = aes(
           x = as.Date(Publikacja,"%d.%m.%Y"),
          y = df2[input$in_rb_partie],
           color = Osrodek))  + 
         xlab("Poll publication date") + 
         ylab("Percent") + theme(plot.margin = margin(0, 0, 0, 1, "cm"))
     }, bg="transparent")
     
     output$dt_extended_table<-renderDataTable({
       df2[df2$Osrodek == input$in_si_osrodek & df2$Zleceniodawca == input$in_si_zamawiajacy,]
         })
     
     # Magda ##################################################################################
     output$results <-renderDataTable(df2)
     
     output$word_freq_magda <- renderPlot({
       word_freq_magda() 
     }, bg="transparent")
}

word_freq_magda <- function() {
  
  filePath <- paste(getwd(),"parties_en.txt",sep = "/") # zawiera polskie znaki, Corpus nie jest w stanie ich obsluzyc
 # filePath <- paste(getwd(),"lorem_ipsum.txt",sep = "/")
  
  txt <- read_lines(filePath)

  docs <- Corpus(VectorSource(txt))
  
  docs <- tm_map(docs, tolower) #mniejszy rozmiar liter
 
  docs <- tm_map(docs, removeNumbers) #usuwanie liczb
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