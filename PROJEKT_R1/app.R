#install.packages("shinydashboard")
library(shinydashboard)
library(RPostgreSQL)
library(plyr)
library(dplyr)
library(scales)
library(wordcloud)
library(syuzhet)
library(tidyverse)

ui <- dashboardPage(
  # HEADER
  ################################################################################################
  dashboardHeader(title = "Polls analysis"
                  #,dropdownMenu(type = "tasks",
                  #             taskItem("ABC")
                  #             )
                  ),
  # SIDEBAR
  ################################################################################################
  dashboardSidebar(
    sidebarMenu(
      menuItem("Political party", tabName = "tab_partie", icon = icon("th")),
      
      menuItem("Results", tabName = "tab_wyniki_ogolne", icon = icon("dashboard"),  badgeColor = "green",
               menuSubItem("General results", tabName = "tab_wyniki_ogolne", icon = icon("th")),
               menuSubItem("Detailed results", tabName = "tab_wyniki_szczegolowe", icon = icon("th"))
               ),
      
      menuItem("Text mining (DEV)", tabName = "tab_text_mining", icon = icon("th"),
               menuSubItem("Word frequencies", tabName = "tab_text_mining_czestosc_slow", icon = icon("th")),
               menuSubItem("Word cloud", tabName = "tab_text_mining_chmura_slow", icon = icon("th")),
               menuSubItem("Find freq terms", tabName = "tab_text_mining_czestosci", icon = icon("th")),
               menuSubItem("Associacis", tabName = "tab_text_mining_asocjacje", icon = icon("th")),
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
                infoBox("TEST",  "TEST", icon = icon("credit-card")),
                infoBoxOutput("winRate")
              )
      ),
      
      # Wyniki
      ################################################################################################
      #ogolne
      tabItem(tabName = "tab_wyniki_ogolne",
              fluidRow(
                h2("General results")
              )
      ),
      
      tabItem(tabName = "tab_wyniki_szczegolowe",
              fluidRow(
                h2("Detailed results")
              )
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
                h2("Text mining :: word frequencies")
              )
      ), 
      tabItem(tabName = "tab_text_mining_chmura_slow",
              fluidRow(
                h2("Text mining :: word cloud")
              )
      ),      
      tabItem(tabName = "tab_text_mining_czestosci",
              fluidRow(
                h2("Text mining :: findFreqTerms")
              )
      ), 
      tabItem(tabName = "tab_text_mining_asocjacje",
              fluidRow(
                h2("Text mining :: associacions")
              )
      ),   
      tabItem(tabName = "tab_text_mining_emocje",
              fluidRow(
                h2("Text mining :: emotions")
              )
      ),  
      tabItem(tabName = "tab_text_mining_sentyment",
              fluidRow(
                h2("Text mining :: sentiment")
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


server <- function(input, output) {

  

}


shinyApp(ui, server)