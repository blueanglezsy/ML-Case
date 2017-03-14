# Load libraries
library(ggplot2)
library(hexbin)

# Read data
untar("C:/Users/syzha/Desktop/New folder/OpenDoor/knn_data.tar.gz",list=TRUE) 
data = untar("C:/Users/TKN005L/Desktop/DS/R Case/OD/knn_data.tar.gz")
data = read.csv("data.csv")
data = data[order(data$close_date),]
test = data[1:100,]
test = test[order(test$close_date),]

# KNN Implementation 1: temporal prediction
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
    weight <- 1/dsq
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

# Looking into the error trend by time
data_knn1$RAE <- abs(data_knn1$KNNPredictions - data_knn1$close_price)/data_knn1$close_price
data_knn1$close_date <= as.Date(data_knn1$close_date)
ggplot(data = data_knn1, aes(x = close_date, y = RAE)) +
  geom_line()

# Looking into the error trend by spatial
ggplot(data = data_knn1, aes(latitude, longitude)) +
  stat_summary_hex(fun = function(x) median(x))
  
# Select the optimal k by CV






# KNN Implementation 2: predict test based on previous records








