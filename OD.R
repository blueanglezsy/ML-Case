# Load libraries

# Read data
untar("C:/Users/syzha/Desktop/New folder/OpenDoor/knn_data.tar.gz",list=TRUE) 
data = untar("C:/Users/TKN005L/Desktop/DS/R Case/OD/knn_data.tar.gz")
data = read.csv("data.csv")
data$close_date = as.Date(data$close_date)
attach(data)
data = data[order(close_date),]
test = data[1:100,]

# KNN Implementation 1: calculate knn based on previous records
knn <- function(df, k){
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

test <- transform(test, KNNPredictions = knn(test, 4))

sum(with(df, Label != kNNPredictions))

# KNN Implementation 2: predict test based on previous records




###################################################################################################
installation.probability <- function(user, package, user.package.matrix, distances, k = 25)
{
  neighbors <- k.nearest.neighbors(package, distances, k = k)
  
  return(mean(sapply(neighbors, function (neighbor) {user.package.matrix[user, neighbor]})))
}

installation.probability(1, 1, user.package.matrix, distances)
#[1] 0.76

# Fourteenth code snippet
most.probable.packages <- function(user, user.package.matrix, distances, k = 25)
{
  return(order(sapply(1:ncol(user.package.matrix),
                      function (package)
                      {
                        installation.probability(user,
                                                 package,
                                                 user.package.matrix,
                                                 distances,
                                                 k = k)
                      }),
               decreasing = TRUE))
}

user <- 1

listing <- most.probable.packages(user, user.package.matrix, distances)

colnames(user.package.matrix)[listing[1:10]]








