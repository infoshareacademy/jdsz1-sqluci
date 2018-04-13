library(ggplot2)
library(FactoMineR)
library(factoextra)
library(kernlab)
library(plotly)
library(combinat)
library(gdata)
library(reshape)

data("mtcars")


#distribution plots
ggplot(melt.data.frame(mtcars), aes (value)) +
  geom_histogram(bins=12,aes(y=..density..)) + geom_density() + 
  facet_wrap(~variable,scales = "free")



nc <- ncol(mtcars) #number of dataframe columns
hdr <- colnames(mtcars) # header (dataframe column names)

#correlation matrix
C <- round(cor(mtcars),3) #create correlation matrix
lowerTriangle(C) <- NA #for better readibility purge lower triangular part
print(C)

pairs(mtcars)

#choose pairs of variables that may be interesting (linearly)
interesting_correlation_level <- 0.5
vlist <- list()
plist <- list()
k<-0
for (i in 1:nc)
{
  if (i==nc) #yes! I am R and I don't care about being fast! I never have..., use while and stop complaining
    vec <- NULL
  else 
    vec <- (i+1):nc

  for (j in vec){
     if (abs(C[i,j]) > interesting_correlation_level)
     {
       #print(c(hdr[i],hdr[j]))
       k <- k+1
       vlist[[k]] <- c(hdr[i],hdr[j])
       local ({
         i<-i
         j<-j
         p <- ggplot(mtcars) + geom_point(aes( x= mtcars[hdr[i]], y= mtcars[hdr[j]] )) +xlab(hdr[i]) +ylab(hdr[j])
         plist[[k]] <<- p}) #symbolic manipulation in R is a scam!
     }
  }
}

{ #yeah, manually! It is R for Gods sake!
#i <- 1:9
#i <- 10:18
#i <- 19:27  
i <- 28:36
    multiplot(plotlist = plist[i], cols = 3)
}

linvlist <- c(1,2,4,5,6,7,9,10,11,13,15,16,18,21,28,32,33,35,36) #list of potentially interesting linear correlations (chosen manually)
multiplot(plotlist = plist[linvlist], cols = 3) #multiplot definition in different source file


gPCAreduced <- PCA(mtcars[c("mpg","disp","hp","drat","wt","qsec")], scale.unit = TRUE, ncp = 6, graph = TRUE)
dPCAreduced <- PCA(mtcars[c("mpg","disp","hp","drat","wt","qsec")], scale.unit = TRUE, ncp = 6, graph = FALSE)


#check for combinations of three variables
var_com <- combn(1:ncol(mtcars),3) #variable combinations for linear models

SMSE <- rep(NA, ncol(var_com) )
models <- list()
vars3 <- list()
for (j in 1:ncol(var_com)) #extremely slow - sue me! 
{
  columns <- var_com[,j]
  x <- mtcars[columns[1]][[1]]
  y <- mtcars[columns[2]][[1]]
  z <- mtcars[columns[3]][[1]]
  
  lmodel <- lm(z~x+y)
  
  models[[j]] <- lmodel
  
  a0 <- lmodel$coefficients[1]
  a1 <- lmodel$coefficients[2]
  a2 <- lmodel$coefficients[3]
  
  pz <- a0+a1*x+a2*y
  
  SMSE[j] <- sqrt( sum((pz - z)^2) )
}

summarySMSE <- summary(SMSE)
bestLMtreshold <- summarySMSE[2] #choose the models which are in the smalles 25% errors

bestLM <- models[SMSE <= bestLMtreshold]
bestVarForLinearFit <- var_com[,SMSE <= bestLMtreshold] #best variables for linear models (mtcars column indexes)

bestTriples <- matrix(hdr[bestVarForLinearFit],nrow=3,ncol = ncol(bestVarForLinearFit)) #triples of variables from the best linear models of three vars

cts <- table(hdr[bestVarForLinearFit]) #frequency of well correlated variables




#kPCA with some assumed params
kpc <- kpca(~.,data=mtcars,kernel="rbfdot",
            kpar=list(sigma=0.2),features=ncol(mtcars))

#print the principal component vectors
PC <-pcv(kpc)


mtc = mtcars

mtc$am[which(mtcars$am == 0)] <- 'Automatic'
mtc$am[which(mtcars$am == 1)] <- 'Manual'
mtc$am <- as.factor(mtc$am)

mtc$pc1 <- PC[,1]
mtc$pc2 <- PC[,2]
mtc$pc3 <- PC[,3]







