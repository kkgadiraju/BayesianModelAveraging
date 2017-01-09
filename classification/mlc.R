################################################
## Maximum Likelihood Classifier
# Each p(x|y = ci)  N(i, i)
# Krishna Karthik Gadiraju/kgadira
################################################




rm(list=ls(all=T))
library(rgdal)
library(rgeos)

calculateMeans <- function(data){
  means <- apply(data[,-1],2, mean)
  means  
}

calculateCov <- function(data){
  covs <- cov(data[,-1])
  covs
}

disc <- matrix(0,3504900,4)
calculateDiscriminant <- function(j,d,means,covs,apriori){
  for(i in 1:4){
  disc[j,i] <<- -0.5*(as.matrix(d[j,-1]-means[[i]])%*%(solve(covs[[i]]))%*%(t(as.matrix(d[j,-1]-means[[i]]))))+log(apriori[i])-(5/2)*log(2*pi)- (1/2)*det(covs[[i]])
  print(paste(j,i, disc[j,i]))
	}
}


MLE <- function(training){
  
  data <- read.csv(training)
  data$Class <- as.factor(data$Class)
  
  classSplit <- split(data,data$Class)
  
  means <- lapply(classSplit,calculateMeans) 
  
  print('means results calculated')
 
  print(means)

  covs <- lapply(classSplit,calculateCov) 
  
  print('covs calculated')
  
  print(covs)
  apriori <- rep(0,4)
  for(i in 1:4){
    apriori[i] <- nrow(classSplit[[i]])/(nrow(classSplit[[1]])+nrow(classSplit[[2]])+nrow(classSplit[[3]])+nrow(classSplit[[4]]))
  }

  data.1 <- read.csv('../training/2015-04-19-AllBands.csv')
  
  sapply(1:nrow(data.1), calculateDiscriminant, data.1,means, covs, apriori)
  
 write.csv(file='../training/mlc-results.csv',x = disc, row.names=F)  
  
  
}

MLE('../training/2015-04-19-AllBands-Clipped-training.csv')


