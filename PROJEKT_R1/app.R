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
library(tm)
library(SnowballC)
library(RColorBrewer)
#unimportnt commit
# locale test  ąćł


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
      menuItem("Political party"),
      
      menuItem("Results", tabName = "tab_wyniki_ogolne", icon = icon("dashboard"),  badgeColor = "green",
               menuSubItem("General results", tabName = "tab_wyniki_ogolne", icon = icon("th")),
               menuSubItem("Detailed results", tabName = "tab_wyniki_szczegolowe", icon = icon("th")),
               menuSubItem("Results by party", tabName = "tab_wyniki_partie", icon = icon("th"))
      ),
      
      menuItem("Text mining (DEV)", tabName = "tab_text_mining", icon = icon("th"),
               menuSubItem("Word frequencies", tabName = "tab_text_mining_czestosc_slow", icon = icon("th")),
               menuSubItem("Word cloud", tabName = "tab_text_mining_chmura_slow", icon = icon("th")),
               menuSubItem("Find freq terms", tabName = "tab_text_mining_czestosci", icon = icon("th")),
               menuSubItem("Associacis", tabName = "tab_text_mining_asocjacje", icon = icon("th")),
               menuSubItem("Emotions", tabName = "tab_text_mining_emocje", icon = icon("th")),
               menuSubItem("Sentiment", tabName = "tab_text_mining_sentyment", icon = icon("th")),
               menuSubItem("Twitter", tabName = "tab_text_mining_twitter", icon = icon("th")),
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
              ),
              
              fluidRow(
                column(width = 10,
                       dataTableOutput("results")
                )
              )
      ),
      
      tabItem(tabName = "tab_wyniki_szczegolowe",
              fluidRow(h2("Detailed results")),
              fluidRow(
                radioButtons("in_rb_partie", label = h3("Partia polityczna"),
                             choices = list("A","B"),
                             inline = TRUE
                ),
                fluidRow(plotOutput("plot_partie"))
              ),
              fluidRow(h3("Test"),
                       bootstrapPage(
                         div(style="display:inline-block", selectInput("in_si_osrodek", "Osrodek:",c("A","B"),multiple = TRUE) ), 
                         div(style="display:inline-block", selectInput("in_si_zamawiajacy", "Zamawiajacy:",c("A","B") ,multiple = TRUE)) 
                       ),
                       dataTableOutput("dt_extended_table"))
      ),     
      tabItem(tabName = "tab_wyniki_partie",
              fluidRow(h2("Results by party")),
              fluidRow(plotOutput("plot_partie_facet"))
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
              ),
              fluidRow(
                column(width = 6, plotOutput("word_freq_magda")
                )
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
              ),
              
              fluidRow(
                textInput(inputId = "ass_text",
                             label = "Terms:",
                             value = "win"),
                
                numericInput(inputId = "ass_cor",
                             label = "CorLimit:",
                             value = 1 )
              ),
              fluidRow(
                verbatimTextOutput("find_ass")
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
      tabItem(tabName = "tab_text_mining_twitter",
              fluidRow(
                h2("Text mining :: twitter")
              ),
              fluidRow(
                verbatimTextOutput("twitter")
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
    
    daty <- c(df2$Publikacja,df2$Publikacja,df2$Publikacja,df2$Publikacja,
              df2$Publikacja,df2$Publikacja,df2$Publikacja,df2$Publikacja)
    
    metoda_badania <- c(df2$`Metoda badania`,df2$`Metoda badania`,df2$`Metoda badania`,df2$`Metoda badania`,
                        df2$`Metoda badania`,df2$`Metoda badania`,df2$`Metoda badania`,df2$`Metoda badania`)
    
    wynik <- c(df2$PiS,
               df2$PO,
               df2$`K'15`,
               df2$SLD,
               df2$.N,
               df2$PSL,
               df2$`PARTIA RAZEM`,
               df2$WOLNOSC)
    
    partia <- c(rep("PiS",length(df2$PiS)),
                rep("PO",length(df2$PO)),
                rep("K'15",length(df2$`K'15`)),
                rep("SLD",length(df2$SLD)),
                rep(".N",length(df2$.N)),
                rep("PSL",length(df2$PSL)),
                rep("PARTIA RAZEM",length(df2$`PARTIA RAZEM`)),
                rep("WOLNOSC",length(df2$WOLNOSC))   
                ) 
    
    df3 <- data.frame(daty,wynik,partia,metoda_badania)  
    most_popular_method <- tail(names(sort(table(df2$`Metoda badania`))),1)
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
     
     output$plot_partie_facet <- renderPlot({ 
       ggplot(data = df3[df3$metoda_badania == most_popular_method,]) + 
       geom_point(mapping = aes(
         x = as.Date(daty,"%d.%m.%Y"),
         y = wynik)
       ) +   geom_smooth(mapping = aes(
         x = as.Date(daty,"%d.%m.%Y"),
         y = wynik)) + 
       facet_wrap(~ partia, ncol = 2) })
     
     # Magda ##################################################################################
     output$results <-renderDataTable(df2)
     
     output$word_freq_magda <- renderPlot({
       word_freq_magda() 
     }, bg="transparent")

  
  # Magda ##################################################################################
  output$results <-renderDataTable(df2)
  
  output$word_freq_magda <- renderPlot({
    word_freq_magda() 
  }, bg="transparent")

  # Twitter (Magda)
  twitter()
  output$twitter <- renderPrint({ 
  })

  # Associations (Magda)
  output$find_ass <- renderPrint({
    findAssocs(dtm, terms = input$ass_text, corlimit = input$ass_cor)
  })

  # Word Freq (Magda)
  
  word_freq_magda()
  output$word_freq_magda <- renderPlot({
    ggplot(data = head(d,50), mapping = aes(x = reorder(word, freq), y = freq)) +
      geom_bar(stat = "identity") +
      xlab("Word") +
      ylab("Word frequency") +
      coord_flip() 
  }, bg="transparent")

  
  # General results (Magda)
  
  results()
  output$results <-renderDataTable(df2)
  

}

results <- function() {      #funkcja results Magdy
  library(XML)
  library(RCurl)
  library(tidyr)
  link <- "https://docs.google.com/spreadsheets/d/1P9PG5mcbaIeuO9v_VE5pv6U4T2zyiRiFK_r8jVksTyk/htmlembed?single=true&gid=0&range=a10:o400&widget=false&chrome=false" 
  xData <- getURL(link)  #get link
  dane_z_html <- readHTMLTable(xData, stringsAsFactors = FALSE, skip.rows = c(1,3), encoding = "utf8") #read html
  df_dane <- as.data.frame(dane_z_html)   #data frame
  colnames(df_dane) <- df_dane[1,]  #nazwy kolumn
  df2 <- df_dane[2:nrow(df_dane),]  #pominięcie pierwszego wiersza
  for (i in 8:16)
    df2[[i]] <- as.numeric(gsub(",",".",df2[[i]]))      #przecinki
  colnames(df2)[2]<- "Osrodek"  #zmiana bo z polskim znakiem nie dzia?a 
  head(df2)
  df2
}


word_freq_magda <- function() {   # word frequency Magdy
  library(tm)
  library(SnowballC)
  library(wordcloud)
  library(RColorBrewer)
  library(tidyverse)
  filePath <- "parties_en.txt"
  text <- read_lines(filePath)
  docs <- Corpus(VectorSource(text))
  docs <- tm_map(docs, tolower) #mniejszy rozmiar
  docs <- tm_map(docs, removeNumbers) #numerki
  docs <- tm_map(docs, removeWords, stopwords("english")) #usuwanie
  docs <- tm_map(docs, removePunctuation) #punktuacja
  docs <- tm_map(docs, stripWhitespace) #białeznaki
  docs2 <-tm_map(docs, stemDocument)   #słowa kluczowe
  dtm <<- TermDocumentMatrix(docs2)      #matryca słów
  m   <- as.matrix(dtm)                   #na matrycę
  v   <- sort(rowSums(m), decreasing=TRUE)   #sortowanie według ilości dec
  d   <<- data.frame(word=names(v), freq=v)  #nowa data frame: słowo, ilość
    ggplot(data = head(d,50), mapping = aes(x = reorder(word, freq), y = freq)) +
    geom_bar(stat = "identity") +
    xlab("Word") +
    ylab("Word frequency") +
    coord_flip() }

twitter <- function() {   # twitter Magdy
  library(rtweet)
  library(httpuv)
  
  appname <- "magda_sentiment_analysis"
  key <- "3d09h36rBQoSThXzaHqnIaezI"
  secret <- "omOF174fJEj8OfwlHUNWfrdtt4NlY9tPyxH7igQcvy3dscOEb3"
}



shinyApp(ui, server)