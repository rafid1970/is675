credit <- read.csv("credit.csv")
library(caret)

## Model Tuning
set.seed(300)
m <- train(default ~ ., data = credit, method = "C5.0")
m

p <- predict(m, credit)
table(p, credit$default)

# predicted classes
head(predict(m, credit, type = "raw"))
# predicted probabilities
head(predict(m, credit, type = "prob"))

### Customized Model Tuning
ctrl <- trainControl(method = "cv", number = 10, selectionFunction = "oneSE")

grid <- expand.grid(.model = "tree", .trials = c(1, 5, 10, 15, 20, 25, 30, 35), .winnow = "FALSE")
grid

# customize train() with the control list and grid of parameters 
set.seed(300)
m <- train(default ~ ., data = credit, method = "C5.0", metric = "Kappa", trControl = ctrl, tuneGrid = grid)
m

## Ensemble Learning
## Bagging

# ipred bagged decision trees
library(ipred)
set.seed(300)
mybag <- bagging(default ~ ., data = credit, nbagg = 25)

credit_pred <- predict(mybag, credit)
table(credit_pred, credit$default)

# estimate performance of ipred bagged trees
set.seed(300)
ctrl <- trainControl(method = "cv", number = 10)
train(default ~ ., data = credit, method = "treebag", trControl = ctrl)


#############################################
##################
#svmBag portions left out due to caret/R version related errors

# general caret bagging function
# create a bag control object using svmBag
str(svmBag)
svmBag$fit

bagctrl <- bagControl(fit = svmBag$fit, predict = svmBag$pred, aggregate = svmBag$aggregate)

# fit the bagged svm model
set.seed(300)
svmbag <- train(default ~ ., data = credit, "bag", trControl = ctrl, bagControl = bagctrl)
svmbag
##################
#############################################

## Boosting
# create a Adaboost.M1 model
library(adabag)
set.seed(300)
m_adaboost <- boosting(default ~ ., data = credit)

p_adaboost <- predict(m_adaboost, credit)
head(p_adaboost$class)
p_adaboost$confusion

# 10-fold cv
set.seed(300)
adaboost_cv <- boosting.cv(default ~ ., data = credit)
adaboost_cv$confusion

# calculate kappa
library(vcd)
Kappa(adaboost_cv$confusion)

## Random Forests
# random forest with default settings
library(randomForest)
set.seed(300)
rf <- randomForest(default ~ ., data = credit)
rf

# set repeated cross-validation for random sampling, repated 10 times over 10 folds
ctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
# set mtry values to set the number of features considered to each split
grid_rf <- expand.grid(.mtry = c(2, 4, 8, 16))

set.seed(300)
m_rf <- train(default ~ ., data = credit, method = "rf", metric = "Kappa", trControl = ctrl, tuneGrid = grid_rf)
m_rf

# auto-tune a boosted C5.0 decision tree
grid_c50 <- expand.grid(.model = "tree", .trials = c(10, 20, 30, 40), .winnow = "FALSE")

set.seed(300)
m_c50 <- train(default ~ ., data = credit, method = "C5.0", metric = "Kappa", trControl = ctrl, tuneGrid = grid_c50)
m_c50