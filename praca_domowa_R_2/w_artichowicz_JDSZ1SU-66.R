library(ggplot2)
library(FactoMineR)
library(factoextra)
library(kernlab)

data("mtcars")


pairs(mtcars)

gPCA <- PCA(mtcars, scale.unit = TRUE, ncp = 5, graph = TRUE)
dPCA <- PCA(mtcars, scale.unit = TRUE, ncp = 5, graph = FALSE)



kpc <- kpca(~.,data=mtcars,kernel="rbfdot",
            kpar=list(sigma=0.2),features=3)

#print the principal component vectors
PC <-pcv(kpc)

#plot the data projection on the components
plot(rotated(kpc),col=mtcars$mpg,
     xlab="1st Principal Component",ylab="2nd Principal Component")

scatter3D(x=PC[,1], y=PC[,2], z=PC[,3],colvar = mtcars$mpg, col = NULL, add = FALSE,clab = "mpg")


