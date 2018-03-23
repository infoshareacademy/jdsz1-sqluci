# devel history:
# https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/R/snippets/stuff/homework.R

rm(list=ls())

# 1) load packages devtools, openxlsx, RPostgreSQL, dplyr
{
    install.packages("devtools")
    library(devtools)
    install.packages("openxlsx")
    library(openxlsx)
    install.packages("RPostgreSQL")
    library(RPostgreSQL)
    install.packages("dplyr")
    library(dplyr)
}

#2 read and build fnction active_packages, which will read all packages from prvious point
# what does it mean to read a function?
{
    active_packages <- function()
    {
      library(devtools)
      library(openxlsx)
      library(RPostgreSQL)
      library(dplyr)
    }
active_packages()
print(active_packages) # == read?
}

#3 run function active_packages in concolse and check whether 
call(active_packages())

# 4) load all data from szczegoly_rekompensat table into data frame called df_compensations
{
    library(dplyr)
    library(RPostgreSQL)
    drv<-dbDriver("PostgreSQL")
    #con<-dbConnect(drv,dbname="postgres",host="localhost",port=5432,user="postgres",password="postgres")
    con<-dbConnect(drv,dbname="wnioskiDB",host="localhost",port=5432,user="postgres",password="postgres")
    if (dbExistsTable(con, "szczegoly_rekompensat")){
       df_compensations<- dbGetQuery(con, "SELECT * from szczegoly_rekompensat")
       print(df_compensations)
    } else {
       df_compensations = {}
    }
    #dbDisconnect(con) #remove in order to execute #5
}

# 5)  check if table tab_1 exists in a connection defined in previous point
dbExistsTable(con, "tab_1")

# 6) print df_compensations data frame summary
print(summary(df_compensations))

# 7) create vector sample_vector which contains numbers 1,21,41 (don't use seq function)
sample_vector <- c(1,21,41)

# 8) create vector sample_vector_seq which contains numbers 1,21,41 (use seq function)
sample_vector_seq <- seq(1,41,20)

# 9) Combine two vectors (sample_vector, sample_vector_seq) into new one: v_combined
v_combined  <- c(sample_vector,sample_vector_seq)

# 10) Sort data descending in vector v_combined
v_combined <- sort(v_combined,decreasing = TRUE)

# 11) Create vector v_accounts created from df_compensations data frame, which will store data from 'konto' column
v_accounts <- df_compensations$konto

# 12)Check v_accounts vector lengt
length(v_accounts)

# 13) Because previously created vector containst duplicated values, we need a new vector (v_accounts_unique), with unique values. Print vector and check its length
{
   v_accounts_unique <- unique(v_accounts)
   length(v_accounts_unique)
}

# 14) Create sample matrix called sample_matrix, 2 columns, 2 rows. Data: first row (998, 0), second row (1,1)
sample_matrix <- rbind(c(998,0),c(1,1))

# 15) Assign row and column names to sample_matrix. Rows: ("no cancer", "cancer"), Columns: ("no cancer", "cancer")
{
    colnames(sample_matrix) <- c("no cancer","cancer")
    rownames(sample_matrix) <- c("no cancer","cancer")
}

# 16) Create 4 variables: precision, recall, acuracy, fscore and calculate their result based on data from sample_matrix
{
    precision <- sample_matrix["cancer","cancer"] / sum(sample_matrix[,"cancer"])
    recall <- sample_matrix["cancer","cancer"] / sum(sample_matrix["cancer",])
    accuracy <- sum(diag(sample_matrix)) / sum(sample_matrix)
    fscore <- 2.* precision*recall /(precision + recall)
}

# 17) Create matrix gen_matrix with random data: 10 columns, 100 rows, random numbers from 1 to 50 inside
#install.packages("purrr")
#library(purrr)
gen_matrix <- matrix(sapply(runif(10*100)*50,{function (x) if (x < 1) 1+x else x}),nrow = 100,ncol = 10)
# lub 
gen_matrix <- sample(1:50,100*10,TRUE)

# 18) Create list l_persons with 3 members from our course. Each person has: name, surname, test_results (vector), homework_results (vector)
l_persons <- list(
                   person1 = list(name = "Monika",surname = "Serkowska",test_results = c(1,2,3),homework_results = c(3,2,1)),
                   person2 = list(name = "Wojtek",surname = "Artichowicz",test_results = c(1,2,3),homework_results = c(3,2,1)),
                   person3 = list(name = "Magdalena",surname = "Kortas",test_results = c(1,2,3),homework_results = c(3,2,1)) 
                  )

# 19) Print first element from l_persons list (don't use $ sign)
print(l_persons[1])

# 20) Print first element from l_persons list (use $ sign)n)
print(l_persons$person1)

# 21) Create list l_accounts_unique with unique values of 'konto' column from df_compensations data frame. Check l_accounts_unique type
l_accounts_unique <- list(unique(df_compensations$konto))

# 22) Create data frame df_comp_small with 4 columns from df_compensations data frame (id_agenta, data_otrzymania, kwota, konto)
df_comp_small <- df_compensations[,c("id_agenta","data_otrzymania","kwota","konto")]

# 23) Create new data frame with aggregated data from df_comp_small (how many rows we have per each account, and what's the total value of recompensations in each account)
df_comp_small %>% 
  group_by(konto) %>%  
       summarise(rows_per_account = n(), recomp_sum = sum(kwota)) -> new_data_frame

# 24) Which agent recorded most recompensations (amount)? Is this the same who recorded most action?
{
    df_comp_small %>% 
       group_by(id_agenta) %>%  
           summarise(actions = n(), recomp_sum = sum(kwota)) -> tmp

    id_agenta_most_recompensations <- tmp[order(tmp$recomp_sum,decreasing = TRUE),]$id_agenta[1]
    print(paste("Which agent recorded most recompensations (amount) " , toString( id_agenta_most_recompensations)))
    
    id_agenta_most_actions <- tmp[order(tmp$actions,decreasing = TRUE),]$id_agenta[1]
    print(paste("Is this the same who recorded most action? " , toString( {function (x) if (x == TRUE) "yes" else "no"}(id_agenta_most_actions == id_agenta_most_recompensations) )))
}

# 25) Create loop (for) which will print random 100 values
for (r in rnorm(100,0,1)){
  print(r)
}

# 26) Create loop (while) which will print random values (between 1 and 50) until 20 wont' appear
{
    r=-1
    while (r != 20) {
       r = sample(1:50,1)
       print(r)
    }
}

# 27) Add extra column into df_comp_small data frame called amount_category. 
df_comp_small$amount_category <- NA

# 28) Store data from df_comp_small into new table in DB
{
    drv<-dbDriver("PostgreSQL")
    con<-dbConnect(drv,dbname="wnioskiDB",host="localhost",port=5432,user="postgres",password="postgres")

    dbWriteTable(con, "comp_small", df_comp_small)
    if (dbExistsTable(con, "comp_small")){
      print("Creating table succeeded.")
    }else
       print("Creating table failed.")
    dbDisconnect(con)
}

# 29) Fill values in amount_category. All amounts below average: 'small', All amounts above avg: 'high'
{
   abs(rnorm(length(df_comp_small$amount_category),3,2)) %>%                  #create random values and pipe them
         {function (X){                                                       # into lambda function which
           m <- mean(X)                                                       # finds mean of the piped argument X and
           return(sapply(X, {function(arg) if (m<arg) "small" else "high"}) ) # maps another lambda choosing proper text
         }}() -> df_comp_small$amount_category                                # save that into the variable  
}

# 30) Create function f_agent_stats which for given agent_id, will return total number of actions in all tables (analiza_wniosku, analiza_operatora etc)
{
  library(dplyr)
  library(RPostgreSQL)
  
  #get agent id and database connection; assuming proper data - no sanity checks
  f_agent_stats <- function (id_agenta, con)
  {
    actions = 0
    for (t in dbListTables(con))          #iterate trough al tables
    {
      for (f in dbListFields(con,t))      #iterate all the fields
        if (grepl('agent', f) )           #if field contains 'agent' then proceed
        {
          query =  paste("SELECT COUNT(",f,") FROM", t,"WHERE",f,"=",toString(id_agenta)) # SQL query counting the agents actions
          actions = actions + dbGetQuery(con,query)[[1]] #sum up SQL the query result
        }
    }
    
    return(actions)
  }  
  
  
  drv<-dbDriver("PostgreSQL")
  con<-dbConnect(drv,dbname="wnioskiDB",host="localhost",port=5432,user="postgres",password="postgres")

  id_agenta = 2
  agent_actions <- f_agent_stats(id_agenta, con)
  print(agent_actions)
  dbDisconnect(con)
}








