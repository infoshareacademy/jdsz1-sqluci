library(ROCR)
library(ggplot2)
library(ggcorrplot)
library(factoextra)
library(FactoMineR)


pth ="C:\\Users\\miser\\Documents\\Projects\\GIT\\DATA_SCIENCE\\jdsz1-sqluci\\PROJEKT_R2\\wojtek\\candy\\"
cdf <- read.csv("candy-data.csv")
head(cdf)

summary(cdf)

#check if data has any NAs
mapply(anyNA, cdf) #nope! go further

#visualizing data
ggplot(cdf) + geom_point(aes(x = sugarpercent,y=pricepercent)) # no dependence
ggplot(cdf) + geom_point(aes(x = sugarpercent,y= winpercent)) # no dependence
ggplot(cdf) + geom_point(aes(x = pricepercent,y= winpercent)) # no dependence

pca_real = FactoMineR::PCA(cdf[c("sugarpercent","pricepercent","winpercent")]) #cannot be linearly separated
print(pca_real$eig)
fviz_screeplot(pca_real) #no reason to leave aneglect any of those

pca_all = FactoMineR::PCA(cdf[c("fruity", "caramel", "peanutyalmondy", "nougat", "crispedricewafer", "hard", "bar", "pluribus", "sugarpercent", "pricepercent", "winpercent")]) #cannot be linearly separated
print(pca_all$eig)
fviz_screeplot(pca_all) #no reason to leave aneglect any of those

cn <- colnames(cdf)
for (i in 2:8)
{
  j=i+1;
  while (j<=8)
  {
    print(paste(cn[i],cn[j],sep=" vs. "))
    print(table(cdf[[i]],cdf[[j]]))
    j=j+1
  }
}


ggplot(cdf[c(1,2)]) + geom_bar(aes(x = chocolate))
