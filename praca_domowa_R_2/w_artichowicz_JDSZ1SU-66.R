library(ggplot2)
library(FactoMineR)
library(factoextra)
library(kernlab)
library(plotly)

data("mtcars")

pairs(mtcars)

gPCA <- PCA(mtcars, scale.unit = TRUE, ncp = 5, graph = TRUE)
dPCA <- PCA(mtcars, scale.unit = TRUE, ncp = 5, graph = FALSE)



kpc <- kpca(~.,data=mtcars,kernel="rbfdot",
            kpar=list(sigma=0.2),features=ncol(mtcars))

#print the principal component vectors
PC <-pcv(kpc)

#plot the data projection on the components
plot(rotated(kpc),col=mtcars$mpg,
     xlab="1st Principal Component",ylab="2nd Principal Component")

mtc = mtcars

mtc$am[which(mtcars$am == 0)] <- 'Automatic'
mtc$am[which(mtcars$am == 1)] <- 'Manual'
mtc$am <- as.factor(mtc$am)

mtc$pc1 <- PC[,1]
mtc$pc2 <- PC[,2]
mtc$pc3 <- PC[,3]

#scatter3D(x=PC[,1], y=PC[,2], z=PC[,3],colvar = mtcars$am, col = NULL, add = FALSE,clab = "mpg")

 plot_ly(mtc, x = ~pc1, y = ~pc2, z = ~pc3, color = ~carb, colors = c('#BF382A', '#0C4B8E')) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'pc1'),
                      yaxis = list(title = 'pc2'),
                      zaxis = list(title = 'pc3')))


ggplot(mtc,aes(mpg)) + geom_histogram(binwidth = 0.25)
