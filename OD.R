# Load libraries
library(ggplot2)
library(hexbin)

# Read data
untar("C:/Users/syzha/Desktop/New folder/OpenDoor/knn_data.tar.gz",list=TRUE) 
data = untar("C:/Users/syzha/Desktop/New folder/OpenDoor/knn_data.tar.gz")
data = read.csv("data.csv")
data = data[order(data$close_date),]
l = nrow(data)
train = data[1:70000,]
test = data[70001:l,]

# KNN Implementation 1: Temporal Prediction adaptive (All records)
knn <- function(df, k){
  df = df[order(df$close_date),]
  n <- nrow(df)
  if (n <= k) stop("k can not be more than n-1")
  neigh <- matrix(0, nrow = n, ncol = k)
  predictions <- rep(NA, n)
  for(i in 2:n) {
    euc.dist <- colSums((as.numeric(df[i, 1:2]) - t(as.matrix(df[1:i-1, 1:2]))) ^ 2)  
    neigh[i, ] <- order(euc.dist)[1:k]
    dsq <- euc.dist[order(euc.dist)[1:k]]
    weight <- ifelse(dsq == 0, .Machine$integer.max/k, 1/dsq)
    predictions[i] <- sum(weight*df$close_price[neigh[i, ]])/sum(weight)
  }
  return (predictions)
}

MRAE <- function(df){
  MRAE <- median(abs(df$KNNPredictions - df$close_price)/df$close_price, na.rm = TRUE)
  return(MRAE)
}

# Make the predictions
data_knn1 <- transform(data, KNNPredictions = knn(data, 4))

# Evaluate the overall performance
MRAE(data_knn1)
summary(data_knn1)
data_knn1[data_knn1$KNNPredictions == Inf,]

# Looking into the error trend by time
data_knn1$RAE <- abs(data_knn1$KNNPredictions - data_knn1$close_price)/data_knn1$close_price
data_knn1$close_date = as.numeric(data_knn1$close_date)
ggplot(data = data_knn1, aes(x = close_date, y = RAE)) +
  geom_line()

# Looking into the error trend by spatial
data_knn1 = data_knn1[-c(1:4),]
ggplot(data = data_knn1, aes(latitude, longitude, z = RAE)) +
  stat_summary_hex (fun = function(x) median(x))

# KNN Implementation 2: Temporal Prediction for test dataset
knn <- function(df_train, df_test, k){
  n_train <- nrow(df_train)
  n_test <- nrow(df_test)
  if (n_train <= k) stop("k can not be more than n-1")
  neigh <- matrix(0, nrow = n_test, ncol = k)
  predictions <- rep(NA, n_test)
  for(i in 1:n_test) {
    euc.dist <- colSums((as.numeric(df_test[i, 1:2]) - t(as.matrix(df_train[1:n_train, 1:2]))) ^ 2)  
    neigh[i, ] <- order(euc.dist)[1:k]
    dsq <- euc.dist[order(euc.dist)[1:k]]
    weight <- ifelse(dsq == 0, .Machine$integer.max/k, 1/dsq)
    predictions[i] <- sum(weight*df_train$close_price[neigh[i, ]])/sum(weight)
  }
  return (predictions)
}
# cbind(neigh, t(dsq), t(df_train$close_price[neigh[i, ]]), predictions)

MRAE <- function(df){
  MRAE <- median(abs(df$KNNPredictions - df$close_price)/df$close_price, na.rm = TRUE)
  return(MRAE)
}

# Make the predictions
data_knn2 <- transform(test, KNNPredictions = knn(train, test, 4))

# Evaluate the overall performance
MRAE(data_knn2)
summary(data_knn2)
data_knn2[data_knn2$KNNPredictions == Inf,]

# Looking into the error trend by time
data_knn2$RAE <- abs(data_knn2$KNNPredictions - data_knn2$close_price)/data_knn2$close_price
data_knn2$close_date = as.numeric(data_knn2$close_date)
ggplot(data = data_knn2, aes(x = close_date, y = RAE)) +
  geom_line()

# Looking into the error trend by spatial
ggplot(data = data_knn2, aes(latitude, longitude, z = RAE)) +
  stat_summary_hex (fun = function(x) median(x))

# Optimize K
best_k = rep(NA, 10)
for (k in 1:10){
  pred <- transform(test, KNNPredictions = knn(train, test, k))
  best_k[k] = MRAE(pred)
}

length(data$close_price[data$close_price < 0])
above_z = subset(data, close_price > 0)
above_z = above_z[order(above_z$close_date),]
l = nrow(above_z)
train = above_z[1:75000,]
test = above_z[75001:l,]
data_knn3 <- transform(test, KNNPredictions = knn(above_z, 4))
  

# KNN Implementation for random sampling setting? 
# (I don't think in our case we should use this one cause our data come into in a temporal manner)
# Select the optimal k by CV
fold <- sample(1:5,75,replace=TRUE)
cvpred <- matrix(NA,nrow=75,ncol=10)
for (k in 1:10){
  for (i in 1:5){
    # cross validation get the error rate plotted by k 
  }
}





