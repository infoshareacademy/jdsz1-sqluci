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
ggplot(cdf) + geom_point(aes(x = sugarpercent,y=pricepercent,col = winpercent)) # no dependence
ggplot(cdf) + geom_point(aes(x = sugarpercent,y= winpercent, col = pricepercent)) # no dependence
ggplot(cdf) + geom_point(aes(x = pricepercent,y= winpercent, col = sugarpercent)) # no dependence

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

ggplot(cdf[c(1,2)]) + geom_bar(aes(x = chocolate))

N = nrow(cdf)
scrambled_index <- sample(1:N)

edge <- round(0.8 *N)
train <- scrambled_index[1:edge]
test <- scrambled_index[(edge+1):N]
feat <- c("fruity", "caramel", "peanutyalmondy", "nougat", "crispedricewafer", "hard", "bar", "pluribus", "sugarpercent", "pricepercent", "winpercent")
target <- "chocolate"

train.df <- cdf[train,c(feat,target)]
model <- glm(chocolate ~.,family=binomial(link='logit'),data=train.df)

summary(model)
anova(model, test="Chisq")


test.df <- cdf[test,c(feat,target)]
pred_choco <- ifelse(predict(model,newdata=test.df,type='response') > 0.5,1,0)

check <- data.frame(predicted = pred_choco,observed = test.df$chocolate)

confusion.matrix <- table(check$predicted,check$observed)

predicted <- factor(c(0, 0, 1, 1))
observed <- factor(c(0, 1, 0, 1))
Y      <- as.vector( confusion.matrix)
confusion.matrix.df <- data.frame(predicted, observed, Y)

ggplot(data =  confusion.matrix.df, mapping = aes(x = observed, y = predicted)) +
  geom_tile(aes(fill = Y), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f",Y)), vjust = 1) +
  scale_fill_gradient(low = "white", high = "steelblue")

chisq_var <- c("chocolate","fruity","bar","winpercent")


ROCRpred <- prediction(pred_choco, test.df$chocolate)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE)


pca_train <- FactoMineR::PCA(train.df)
eigv <- pca_all$ind$coord
pt <- as.numeric(cdf[1,feat])
matrix(pt,11,1)%*%eigv

