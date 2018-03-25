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
  dashboardHeader(title = "JDSZ1 - sample dashboard",
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "Sales Dept",
                                 message = "Sales are steady this month."
                               )
                  )),
  # SIDEBAR
  ################################################################################################
  dashboardSidebar(
    sidebarMenu(
      menuItem("Stats", tabName = "stats", icon = icon("dashboard"), badgeLabel = "new", badgeColor = "green"),
      menuItem("Claims", tabName = "claims", icon = icon("th")),
      menuItem("Sentiment", tabName = "sentiment", icon = icon("th"))
    )
  ),
  
  # BODY
  ################################################################################################
  dashboardBody(
    tabItems(
      # STATS TAB
      ################################################################################################
      tabItem(tabName = "stats",
              fluidRow(
                h2("Overall company KPIs")
              ),
              fluidRow(
                infoBox("New claims",  nrow(filter(wnioski_db, stan_wniosku == "nowy")), icon = icon("credit-card")),
                infoBoxOutput("winRate")
              )
      ),
      
      # CLAIMS TAB
      ################################################################################################
      tabItem(tabName = "claims",
              fluidRow(
                h1("Claims - summary")
              ),
              fluidRow(
                verbatimTextOutput("claims_summary")
              ),
              fluidRow(
                h1("Claims - detailed per claim type")
              ),
              fluidRow(
                column(width = 6, selectInput(inputId = "claimTypeSelector",
                                              label = "Choose a claim type:",
                                              choices = unique(wnioski_db$typ_wniosku)),
                       verbatimTextOutput("claims_summary_per_claim_type")
                ),
                column(width = 6,
                       dataTableOutput("claims_table")
                )
              )
      ),
      
      # SENTIMENT TAB
      ################################################################################################
      tabItem(tabName = "sentiment",
              fluidRow(
                sliderInput(inputId = "sentiment_max",
                            label = "Max words",
                            min = 10, max = 500,
                            value = 200
                ),
                column(width = 6, plotOutput("sentimentPlot")),
                column(width = 6, plotOutput("emotionsPlot"))
              )
      )
      
      
    )
  )
)

server <- function(input, output) {
  #if(exists("wnioski_db")) {
  init_db()
  #}
  #if(exists("v")) {
  init_sentiment_data()
  #}
  
  # STATS TAB
  ################################################################################################
  output$winRate <- renderInfoBox({
    infoBox(
      "Win rate",  percent(nrow(filter(wnioski_db, stan_wniosku == "wyplacony")) / nrow(wnioski_db)), icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$claims_histogram <- renderPlot({
    
  })
  
  # CLAIMS TAB
  ################################################################################################
  output$claims_summary <- renderPrint({
    dataset <- wnioski_db
    summary(dataset)
  })
  
  output$claims_summary_per_claim_type <- renderPrint({
    dataset2 <- filter(wnioski_db, wnioski_db$typ_wniosku == input$claimTypeSelector)
    summary(dataset2)
  })
  
  output$claims_table <- renderDataTable({
    filter(wnioski_db, wnioski_db$typ_wniosku == input$claimTypeSelector)
  })
  
  # SENTIMENT TAB
  ########################################################################################################################
  output$sentimentPlot <- renderPlot({
    wordcloud(words = d$word, freq = d$freq, min.freq = 10,
              max.words=input$sentiment_max, random.order=FALSE, rot.per=0.45, 
              colors=brewer.pal(8, "Dark2"))
  }, bg="transparent")
  
  output$emotionsPlot <- renderPlot({
    ggplot(data = df_emotions, mapping = aes(x = sentiment, y = sent_value, color = sentiment, fill = sent_value)) +
      geom_bar(stat = "identity") +
      xlab("emotion") +
      ylab("words count") +
      theme(axis.text.x=element_text(angle=90, hjust=1)) 
  }, bg="transparent")
}

init_db <- function(){
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, dbname = "pg_2", host = "localhost", port = 5432,
                   user = "postgres", 
                   password = "postgres")
  wnioski_db <- dbGetQuery(con, "SELECT * from wnioski")
  dbDisconnect(con)
  dbUnloadDriver(drv)
}

init_sentiment_data <- function() {
  library("tm")
  library("SnowballC")
  library("wordcloud")
  library("RColorBrewer")
  library(tidyverse)
  filePath <- "http://www.gutenberg.org/cache/epub/103/pg103.txt"
  text <- readLines(filePath)
  docs <- Corpus(VectorSource(text))
  docs <- tm_map(docs, tolower)
  docs <- tm_map(docs, removeNumbers)
  docs <- tm_map(docs, stemDocument)
  docs <- tm_map(docs, removePunctuation)
  docs <- tm_map(docs, stripWhitespace)
  dtm <- TermDocumentMatrix(docs)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <<- data.frame(word = names(v), freq=v)
  
  df_sentiment<-get_nrc_sentiment(as.String(d$word)) # sentiment from unique words
  df_sentiment_transposed <- t(df_sentiment) # transpose data frame from columns to rows
  df_sentiment_final <- data.frame(sentiment=row.names(df_sentiment_transposed), 
                                   sent_value=df_sentiment_transposed, row.names=NULL) # prepare final data frame with emotions in 1st column, values in 2nd
  df_emotions <<- df_sentiment_final[1:8,]
}

shinyApp(ui, server)