#install.packages("shinydashboard")
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
              )
      ),
      
      tabItem(tabName = "tab_wyniki_szczegolowe",
              fluidRow(
<<<<<<< HEAD
                radioButtons("in_rb_partie", label = h3("Partia polityczna"),
                             choices = list("A","B"),
                             inline = TRUE
                      ),
              fluidRow(plotOutput("plot_partie"))
=======
                h2("Szczegolowe wyniki sondazy wyborczych")
>>>>>>> 6a47b8f9c7dda47ce68c17d3843b8a90102567b9
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

<<<<<<< HEAD


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
           y = ,
           color = Osrodek)
         ) +
         geom_smooth(mapping = aes(
           x = as.Date(Publikacja,"%d.%m.%y"),
           y = .N,
           color = Osrodek))       
     })
=======
server <- function(input, output) {
  init_polls()
  
  #parte
  output$wykresy <- renderPlot({
    ggplot(data = df2) + 
      geom_point(mapping = aes(
        x = as.Date(df2$Publikacja,"%d.%m.%y"),
        y = df2$`K'15`,
        color = df2$Osrodek)) +
      geom_smooth(mapping = aes(
        x = as.Date(df2$Publikacja,"%d.%m.%y"),
        y = df2$`K'15`,
        color = df2$Osrodek))})
  
>>>>>>> 6a47b8f9c7dda47ce68c17d3843b8a90102567b9
}


init_polls <- function() {
  link <- "https://docs.google.com/spreadsheets/d/1P9PG5mcbaIeuO9v_VE5pv6U4T2zyiRiFK_r8jVksTyk/htmlembed?single=true&gid=0&range=a10:o400&widget=false&chrome=false" 
  xData <- getURL(link)  #get link
  dane_z_html <- readHTMLTable(xData, stringsAsFactors = FALSE, skip.rows = c(1,3), encoding = "utf8") #read html
  df_dane <- as.data.frame(dane_z_html)   #data frame
  colnames(df_dane) <- df_dane[1,]  #nazwy kolumn
  df2 <- df_dane[2:nrow(df_dane),]  #pominiecie pierwszego wiersza
  for (i in 8:16)
    df2[[i]] <<- as.numeric(gsub(",",".",df2[[i]]))
  
  colnames(df2)[2]<- "Osrodek"  #zmiana bo z polskim znakiem nie dziala 
}



shinyApp(ui, server)