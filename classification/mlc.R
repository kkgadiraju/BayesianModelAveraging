################################################
## Maximum Likelihood Classifier
# Each p(x|y = ci)  N(i, i)
# Krishna Karthik Gadiraju/kgadira
################################################




rm(list=ls(all=T))
library(rgdal)
library(rgeos)



covDets <- rep(0,4)
covInv <- list()
calculateMeans <- function(data){
  means <- apply(data[,-1],2, mean)
  means  
}

calculateCov <- function(data){
  covs <- cov(data[,-1])
  covs
}

disc <- matrix(0,3504900,4)
calculateDiscriminant <- function(j,d,means,apriori){
  current <- d[j,-1]
  sum = 0;
  for(i in 1:4){
  
  currentMean <- means[[i]]
  currentMat <- as.matrix(current - currentMean)
  disc[j,i] <<- -0.5*(currentMat)%*%(solve(covInv[[i]]))%*%(t(currentMat))+log(apriori[i])-(5/2)*log(2*pi)- (1/2)*covDets[i]
  sum = sum + disc[j,i];
	}
  for(k in 1:4){
      disc[j,k] <<- disc[j,k]/sum;
      	 
  if(j%%100000==0){
  print(paste(j,k, disc[j,k]))
  		}
 
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
  
  for(i in 1:4){
    covDets[i] <<- log(det(covs[[i]]))
    covInv[[i]] <<- solve(covs[[i]])
  }
  print('covs calculated')
  
  print(covDets)
  print(covInv)
  apriori <- rep(0,4)
  for(i in 1:4){
    apriori[i] <- nrow(classSplit[[i]])/(nrow(classSplit[[1]])+nrow(classSplit[[2]])+nrow(classSplit[[3]])+nrow(classSplit[[4]]))
  }

  data.1 <- read.csv('../training/2015-04-19-AllBands.csv')
  
  sapply(1:nrow(data.1), calculateDiscriminant, data.1,means, apriori)
  
 write.csv(file='../training/mlc-results.csv',x = disc, row.names=F)  
  
  
}

MLE('../training/2015-04-19-AllBands-Clipped-training.csv')


