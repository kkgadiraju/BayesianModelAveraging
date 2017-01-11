################################################
## Bayesian Model Averaging (BMA), based on probabilities calculated
## from Maximum Likelihood Classifier
## pr(y*=class|x*, trainingData) = sum(pr(y*=class|x*,trainingData, model)*pr(model|trainingData))
# Each p(x|y = ci)  N(i, i)
# Krishna Karthik Gadiraju/kgadira
################################################


rm(list=ls(all=T))
library(rgdal)
library(rgeos)


dates <- c('2015-04-19','2015-12-31','2016-01-16','2016-03-20')

img.data <- read.csv('../training/2015-04-19-AllBands.csv') #original image data

train.probs <- list()
class.probs <- list()
train.data <- list()
model.probs <- rep(0,4)
final.probs <- matrix(0,nrow(img.data),4)
#Read all necessary files
for(i in 1:4){
  
  train.data[[i]] <- read.csv(paste('../training/',dates[i],'-AllBands-Clipped-training.csv',sep='')) #training data for 4 views
  

  train.probs[[i]] <- read.csv(paste('../training/',dates[i],'-mlc-results.csv',sep='')) #MLC probabilties for all classes for 4 views
  

  class.probs[[i]] <- read.csv(paste('../training/',dates[i],'-training-mlc-results.csv',sep='')) #p(y*=class|x*,trainingData, model)
  

}


#calculate the product of probabilities - P(h_i |Training Data) is proportional to P(h_i)*ProductForAllTrainingSamples(P(Each trainingSample(x,y)|Label))
# assuming each model is of equal probability, P(h_i) can be ignored
# P(Each trainingSample(x,y)|Label) is proportional to P(Each trainingY|trainingX, h_i). 
# This is equivalent to calculating the mlc probability for the true class label for each training sample, which is done 
# and stored in train.probs
# Now it is just a question of calculating their product
#=1
#P(xi, yi|j)
productProbabilities <- function(train.data,train.prob){
  print(summary(train.data))
  print(summary(train.prob))[
  product = 1
  for( i in 1:nrow(train.data)){
    product = product * train.prob[i,train.data[i,]$Class] 
  }
  product
}

# This is now the model probs, one for each model.

for(i in 1:4){
  model.probs[i] <- productProbabilities(train.data[[i]], train.probs[[i]])
}


#Now calculate the final probability, which is equal to
# P(class|testData, trainingData) is proportional to sum of values of (P(class|testData, trainingData, model))P(model|trainingData))
# for all models.
# The class that produces highest probability is our target class.
finalProbabilities <- function(i){
  
  best.prob <- -Inf
  best.class <- -1
  if(sum(train.data[i,])==0) #means empty values - assign class5 automatically - we don't care about this data
  {
    img.data[i,]$Class <<- 5
    
  }else{#non zero
  for(j in 1:4){ #loop for 4 classes
    current.class.probs <- rep(0,4)
    for(k in 1:4){ #retrieve corresp. class content from each view - loop for views
      current.class.probs[i] <- class.prob[[k]][i,j]
    }
    final.probs[i,j] <<- sum(current.class.probs*model.probs)
    if(final.probs[i,j]>class.predicted){
      best.class = j #identify best probability
    }
  }
  #once you have final probabilities, and identify which one is best, update it in original matrix
    img.data[i,]$Class <<- 5
  }
}

sapply(1:nrow(img.data),finalProbabilities)

write.csv(x=train.data,file='../training/BMA-FinalClassification.csv',row.names=F) #write final result to disk
