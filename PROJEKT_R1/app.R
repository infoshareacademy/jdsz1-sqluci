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
                infoBox("TEST",  "TEST", icon = icon("credit-card")),
                infoBoxOutput("winRate")
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
                h2("Szczegolowe wyniki sondazy wyborczych")
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

server <- function(input, output) {

}





shinyApp(ui, server)