# load packages devtools, openxlsx, RPostgreSQL, dplyr

library(devtools)
library(openxlsx)
library(RPostgreSQL)
library(dplyr)

# read and build fnction active_packages, which will read all packages from prvious point. 
#Print the text "packages ready" at the end of function

active_packages <- function() 
{
  library(devtools)
  library(openxlsx)
  library(RPostgreSQL)
  library(dplyr)
  print("packages ready")
}

# run function active_packages in concolse and check whether "packages ready" text appreared

# load all data from szczegoly_rekompensat table into data frame called df_compensations

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "postgres", host = "localhost", port = 5432,
                 user = "postgres",
                 password = "postgresql") 
compensations <- dbGetQuery(con, "SELECT * from szczegoly_rekompensat")
df_compensations <- as.data.frame(compensations)

# check if table tab_1 exists in a connection defined in previous point

dbExistsTable(con, "tab_1")

# print df_compensations data frame summary vectors

print(df_compensations)
summary(df_compensations)

# create vector sample_vector which contains numbers 1,21,41 (don't use seq function)

sample_vector <- c(1,21,41)
sample_vector


# create vector sample_vector_seq which contains numbers 1,21,41 (use seq function)

sample_vector_seq <- seq(from = 1, to = 41, by = 20)
sample_vector_seq

# Combine two vectors (sample_vector, sample_vector_seq) into new one: v_combined

v_combined <- sample_vector + sample_vector_seq
v_combined

# Sort data descending in vector v_combined

sort(v_combined, decreasing = TRUE)

# Create vector v_accounts created from df_compensations data frame, which will store data from 'konto' column

v_accounts <- as.vector(df_compensations$konto)
typeof(v_accounts)

#  Check v_accounts vector length

length(v_accounts)

#  Because previously created vector containst duplicated values, we need a new vector (v_accounts_unique), with unique values. Print vector and check its length

v_accounts_unique <- unique(v_accounts, incomparables = FALSE)
v_accounts_unique
length(v_accounts_unique)

MATRIX

#  Create sample matrix called sample_matrix, 2 columns, 2 rows. Data: first row (998, 0), second row (1,1)

sample_matrix <- matrix(c(998,1,0,1), nrow=2, ncol=2)

#  Assign row and column names to sample_matrix. Rows: ("no cancer", "cancer"), Columns: ("no cancer", "cancer")

rownames(sample_matrix) <- c("no cancer","cancer")
colnames(sample_matrix) <- c("no cancer","cancer")
sample_matrix

#  Create 4 variables: precision, recall, acuracy, fscore and calculate their result based on data from sample_matrix

precision <-  sample_matrix[2,2] /(sample_matrix[2,2] + sample_matrix[1,2])
recall <-     sample_matrix[2,2] /(sample_matrix[2,2] + sample_matrix[2,1])
accuracy <-  (sample_matrix[1,1] + sample_matrix[2,2])/(sample_matrix[1,2] + sample_matrix[2,1]+ sample_matrix[1,1] + sample_matrix[2,2])
fscore <- 2*precision*recall/(precision+recall)

precision
recall
accuracy
fscore

# Create matrix gen_matrix with random data: 10 columns, 100 rows, random numbers from 1 to 50 inside   

gen_matrix <- matrix((runif(1000,1,50)), nrow=100, ncol=10)
gen_matrix


LIST
#  Create list l_persons with 3 members from our course. Each person has: name, surname, test_results (vector), homework_results (vector)
l_persons <- list(kurs = "JDSZ1", uczestnicy = 3, name = list("Wojtek","Monika","Magda"), surname = list("Artichowicz","Serkowska","Kortas") ,  
                 test_results = c(100,100,1000),  homework_results = c(50, 50, 50) )
l_persons

#  Print first element from l_persons list (don't use $ sign)
l_persons[[1]]

#  Print first element from l_persons list (use $ sign)

l_persons$kurs

# Create list l_accounts_unique with unique values of 'konto' column from df_compensations data frame. Check l_accounts_unique type
l_accounts <- list(df_compensations$konto)
l_accounts_unique <- unique(l_accounts, incomparables = FALSE)
typeof(l_accounts_unique)
l_accounts_unique

#  Create data frame df_comp_small with 4 columns from df_compensations data frame (id_agenta, data_otrzymania, kwota, konto)
df_comp_small <- data.frame(df_compensations$id_agenta, df_compensations$data_otrzymania, df_compensations$kwota, df_compensations$konto)

#  Create new data frame with aggregated data from df_comp_small 
# (how many rows we have per each account, and what's the total value of recompensations in each account

df_comp_small


df_new <- df_comp_small %>% 
  group_by(df_compensations.konto) %>% 
  summarise (liczba = n(), total_compensation_value = sum(df_compensations.kwota)) 
df_new

# Which agent recorded most recompensations (amount)? Is this the same who recorded most action? 

df_agent <- df_comp_small %>% 
  group_by(df_compensations.id_agenta) %>% 
  summarise (liczba = n(), total_compensation_value = sum(df_compensations.kwota)) 
df_agent

most_rec <- arrange(df_agent, desc(total_compensation_value))
most_rec

most_act <- arrange(df_agent, desc(liczba))
most_act

# Create loop (for) which will print random 100 values

for (i in sample(1:100)) 
print(i)

# Create loop (while) which will print random values (between 1 and 50) until 20 wont appear

liczba <- 0
while(liczba < 20) {
  print(liczba)
  liczba <- sample(1:50, 1)
}

  #  Add extra column into df_comp_small data frame called amount_category. 

amount_category <- data.frame("amount category")
df_comp_small <- cbind(df_comp_small, amount_category)
df_comp_small

  #  Store data from df_comp_small into new table in DB

sqlCreateTable(con, "new table", data.frame(df_comp_small), row.names = TRUE)

  # Fill values in amount_category. All amounts below average: 'small', All amounts above avg: 'high'

avg_kwota <- mean(df_comp_small$df_compensations.kwota)

df_comp_small$amount_category <- ifelse (df_comp_small$df_compensations.kwota < avg_kwota, 'small' ,'high')

dbWriteTable(con, "df_comp_small", df_comp_small)


  # Create function f_agent_stats which for given agent_id, 
# will return total number of actions in all tables (analiza_wniosku, analiza_operatora etc)

f_agents_stats <- 
  
  df_agent <- df_comp_small %>% 
  group_by(df_compensations.id_agenta) %>% 
  summarise (liczba = n(), total_compensation_value = sum(df_compensations.kwota)) 
df_agent
