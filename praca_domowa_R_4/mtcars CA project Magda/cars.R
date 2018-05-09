
library(e1071)
library(FactoMineR)
library(factoextra)
library(gplots)
data("mtcars")
?mtcars
mtcars
str(mtcars)

####

normalize <- function(x){
  return((x-min(x))/(max(x)-min(x)))     #normalazing dataset
}

mtcars$mpg <- normalize(mtcars$mpg)
mtcars$cyl <- normalize(mtcars$cyl)
mtcars$disp <- normalize(mtcars$disp)
mtcars$hp <- normalize(mtcars$hp)
mtcars$drat <- normalize(mtcars$drat)
mtcars$wt <- normalize(mtcars$wt)
mtcars$qsec <- normalize(mtcars$qsec)
mtcars$vs <- normalize(mtcars$vs)
mtcars$am <- normalize(mtcars$am)
mtcars$gear <- normalize(mtcars$gear)
mtcars$carb <- normalize(mtcars$carb)

mtcars

dt <- as.table(as.matrix(mtcars))   # all to table
dt


###

balloonplot(t(dt), main = "mtcars", xlab="", ylab="", 
            label = TRUE, show.margins = FALSE)  #graph of contingency table
#size of balloon means numeber of occurences - similar sizes of balloons in case of mtcars

ca_result <- CA(dt, graph =FALSE)
print(ca_result)     #CA results: The row variable has  32  categories; the column variable has 11 categories
                     # The chi square of independence between the two variables is equal to 91.80067 (p-value =  1 )

eig.val <- get_eigenvalue(ca_result)  #eigenvalue correlation explanation
eig.val # Two first dimensions explain 87% (cumulative variance percent), typical boundary: 80% cumulative variance
fviz_screeplot(ca_result, addlabels = TRUE, ylim = c(0,50)) #correlation explanation plotted 

fviz_contrib(ca_result, choice = "row", axes = 1, top = 10) #contribution to  dim1: Honda Civic the highest contribution to Dim-1
# hovewer many cars share similar contribution # the highest influence if point goes left or right
fviz_contrib(ca_result, choice = "row", axes = 2, top = 10) #contribution to  dim2: Masarati Bora the highest contributuon to Dim-2
# hovewer many cars share similar contributuion # the highest influence if point goes up or down

fviz_ca_biplot(ca_result, col.row = "contrib", repel = TRUE) #symmetric plot
#Points with similar profile are closer on the factor map

### for 3 pairs only

# Making CA for 32 row categories and 3 column variables: Error: Each group consists of only one observation. Not enough data to make biplot for CA
# Making CA for 3 row categories and 3 column variables (3 pairs): not enough data to draw interesting conclusions
# Making CA for 32 row categories and 2 column variable (1 pair): Each group consists of only one observation. Not enough data to make biplot for CA
  
dt1 <- as.table(as.matrix(mtcars[c(1:32),c(1:3)])) 
dt1
dt2 <- as.table(as.matrix(mtcars[c(1:3),c(1:3)])) 
dt2
dt3 <- as.table(as.matrix(mtcars[c(1:32),c(1:2)])) 
dt3

balloonplot(t(dt1), main = "mtcars", xlab="", ylab="",  label = TRUE, show.margins = FALSE) 
ca_result1 <- CA(dt1, graph =FALSE)
print(ca_result1)    
eig.val1 <- get_eigenvalue(ca_result1) 
eig.val1 
fviz_screeplot(ca_result1, addlabels = TRUE, ylim = c(0,50))
fviz_contrib(ca_result1, choice = "row", axes = 1, top = 10) 
fviz_contrib(ca_result1, choice = "row", axes = 2, top = 10) 
fviz_ca_biplot(ca_result1, col.row = "contrib", repel = TRUE)

