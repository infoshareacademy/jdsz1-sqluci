# ZADANIE

library(e1071)
data("mtcars")
head(mtcars)
?mtcars
str(mtcars)

# Scatter plot - sprawdzamy czy może istnieć liniowa zależnośc pomiędzy zmiennymi.
par(mfrow=c(3,4))

scatter.smooth(x=mtcars$mpg, y=mtcars$cyl, main="MPG & Cyl") #odwrotna proporcjonalność
abline(lm(mtcars$cyl ~ mtcars$mpg), col="blue", lwd=3)

scatter.smooth(x=mtcars$mpg, y=mtcars$disp, main="MPG & Disp") #odwrotna proporcjonalność
abline(lm(mtcars$disp ~ mtcars$mpg), col="blue", lwd=3)

scatter.smooth(x=mtcars$mpg, y=mtcars$hp, main="MPG & hp") #odwrotna proporcjonalność (duży błąd)
abline(lm(mtcars$hp ~ mtcars$mpg), col="blue", lwd=3)

scatter.smooth(x=mtcars$mpg, y=mtcars$drat, main="MPG & drat") #proporcjonalnie (duży błąd)
abline(lm(mtcars$drat ~ mtcars$mpg), col="blue", lwd=3)

scatter.smooth(x=mtcars$mpg, y=mtcars$wt, main="MPG & wt")  #odwrotna proporcjonalność
abline(lm(mtcars$wt ~ mtcars$mpg), col="blue", lwd=3)

scatter.smooth(x=mtcars$mpg, y=mtcars$qsec, main="MPG & qsec") #słaba zależność
abline(lm(mtcars$qsec ~ mtcars$mpg), col="blue", lwd=3)


scatter.smooth(x=mtcars$mpg, y=mtcars$vs, main="MPG & vs")  # proporcjonalnie (duży błąd)
abline(lm(mtcars$vs ~ mtcars$mpg), col="blue", lwd=3)

scatter.smooth(x=mtcars$mpg, y=mtcars$am, main="MPG & am") #słaba zależność
abline(lm(mtcars$am ~ mtcars$mpg), col="blue", lwd=3)

scatter.smooth(x=mtcars$mpg, y=mtcars$gear, main="MPG & gear") #słaba zależność
abline(lm(mtcars$gear ~ mtcars$mpg), col="blue", lwd=3)

scatter.smooth(x=mtcars$mpg, y=mtcars$carb, main="MPG & carb") #słaba zależność
abline(lm(mtcars$carb ~ mtcars$mpg), col="blue", lwd=3)


# BoxPlot – sprawdzamy czy istnieją wartości mocno odstające od reszty
par(mfrow=c(2,2))
boxplot(mtcars$mpg, main="mpg") # spora roznica miedzy 3 kwartylem a max
boxplot(mtcars$cyl, main="cyl") # rozklad idealny
boxplot(mtcars$disp, main="disp") # roznica  miedzy 3 kwartylem a max, między medianą a 3 kwartylem
boxplot(mtcars$hp, main="hp") # roznica  miedzy 3 kwartylem a max, między medianą a 3 kwartylem

par(mfrow=c(2,2))
boxplot(mtcars$drat, main="drat") #roznica miedzy 3 kwar. a max, miedzy 1 kwart. a mediana
boxplot(mtcars$wt, main="wt")  # roznica miedzy 1 kwart. a mediana
boxplot(mtcars$qsec, main="qsec") # roznica miedzy min a 1 kwart. 
boxplot(mtcars$vs, main="vs") # mediana = min

par(mfrow=c(2,2))
boxplot(mtcars$am, main="am") # mediana = min
boxplot(mtcars$gear, main="gear") #  3 kwart = mediana
boxplot(mtcars$carb, main="carb") # 1 kwart = mediana


# Funkacja gęstośći - sprawdzamy czy zmienna zależna ma rozkład normalny
par(mfrow=c(3,4))
plot(density(mtcars$mpg), main="Mpg", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$mpg), 1)))
polygon(density(mtcars$mpg), col="violet") # pozytywna skośność

plot(density(mtcars$cyl), main="Cyl", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$cyl), 1)))
polygon(density(mtcars$cyl), col="violet") # mała ujemna skośność

plot(density(mtcars$disp), main="Disp", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$disp), 1)))
polygon(density(mtcars$disp), col="violet") # pozytywna skośność

plot(density(mtcars$hp), main="hp", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$hp), 1)))
polygon(density(mtcars$hp), col="violet") #duża pozytywna skośność

plot(density(mtcars$drat), main="drat", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$drat), 1)))
polygon(density(mtcars$drat), col="violet") # mała pozytywna skośność

plot(density(mtcars$wt), main="wt", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$wt), 1)))
polygon(density(mtcars$wt), col="violet") # pozytywna skośność

plot(density(mtcars$qsec), main="qsec", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$qsec), 1)))
polygon(density(mtcars$qsec), col="violet") #pozytywna skośność

plot(density(mtcars$vs), main="vs", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$vs), 1)))
polygon(density(mtcars$vs), col="violet") #mała pozytywna skośność

plot(density(mtcars$am), main="am", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$am), 1)))
polygon(density(mtcars$am), col="violet") #pozytywna skośność

plot(density(mtcars$gear), main="gear", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$gear), 1)))
polygon(density(mtcars$gear), col="violet") # duża pozytywna skośność

plot(density(mtcars$carb), main="carb", ylab="Częstotliwość",
     sub=paste("Skośność:", round(e1071::skewness(mtcars$carb), 1)))
polygon(density(mtcars$carb), col="violet") # bardzo duża pozytywna skośność


# Korelacja

cor(mtcars$mpg, mtcars$cyl) # duża ujemna korelacja / 
cor(mtcars$mpg, mtcars$disp) # duża ujemna korelacja / 
cor(mtcars$mpg, mtcars$wt) # duża ujemna korelacja / 
cor(mtcars$mpg, mtcars$hp) #  ujemna korelacja  / 
cor(mtcars$mpg, mtcars$drat) #  pozytywna korelacja  / 
cor(mtcars$mpg, mtcars$vs) # pozytywna korelacja
cor(mtcars$mpg, mtcars$qsec) # brak / 
cor(mtcars$mpg, mtcars$am) # mała pozytywna korelacja  / 
cor(mtcars$mpg, mtcars$gear) # brak / 
cor(mtcars$mpg, mtcars$carb) # mała ujemna korelacja / 




