# This file creates a logistic regression model using R
# It will train on train.csv output from relay_data_analysis.ipynb
# It will predict on test.csv output from relay_data_analysis.ipynb
dftrain <- read.csv('train.csv')
dftest <- read.csv('test.csv')
# columns to keep
cols <- c('esent','eopenrate','eclickrate','avgorder','ordfreq','paperless','y')
dftrain <- dftrain[, cols]
dftest <- dftest[, cols]
# model
mod <- glm(y~., family = binomial(link = logit), data = dftrain)
# predict test set
preds <- predict(mod, newdata = dftest, type = 'response')
preds <- ifelse(preds > 0.5, 1, 0)
# confusion matrix
cmat <- table(preds, dftest$y)
# accuracy
sum(diag(cmat)) / sum(cmat)

