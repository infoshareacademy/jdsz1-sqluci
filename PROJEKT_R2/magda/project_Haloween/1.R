# Can you predict if a candy is chocolate or not based on its other features?
library(ROCR)
library(text2vec)
library(data.table)
library(magrittr)
library(glmnet)

dim(candy_data)
#####

setDT(candy_data)  # do data table
set.seed(9999)  # randomowe

candy_id = candy_data$competitorname
train_id = sample(candy_id, 58)
test_id = setdiff(candy_id, train_id)
train = candy_data[J(train_id)]
test = candy_data[J(test_id)]

#####

train$fruity <- factor(train$fruity)   #factory 
train$caramel <- factor(train$caramel)
train$peanutyalmondy <- factor(train$peanutyalmondy)
train$nougat <- factor(train$nougat)
train$crispedricewafer <- factor(train$crispedricewafer)
train$hard <- factor(train$hard)
train$bar <- factor(train$bar)
train$pluribus <- factor(train$pluribus)

glm_model <- glm(chocolate ~ caramel + peanutyalmondy + nougat + hard + bar + pluribus, 
                 data = train, family = "binomial") #glm model

if_chocolate <- predict(glm_model, train, type="response")  #prediction

chocolate_results <- cbind(train, if_chocolate) #łączenie do tabelki

table(train$chocolate, if_chocolate > 0.9)  #matryca TRUE positives i FALSE negatives

######################

preds = predict(glm_model, test, type = 'response')

ROCRpred <- prediction(preds, test$chocolate)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE)

table(test$chocolate, preds > 0.9)
final_data <- cbind(test, preds)

glmnet:::auc(test$chocolate, preds)   #### AUC    0.833

