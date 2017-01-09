################################################
##Read extracted CSV, verify properties
# split into training and test
# Krishna Karthik Gadiraju/kgadira
################################################




rm(list=ls(all=T))
library(rgdal)
library(rgeos)
library(foreign)



splitData <- function(data.all, x2, fname){
data.all <- data.all[x2,]

#messed up the original id attribute in QGIS, redo it
id <- seq.int(nrow(data.all))
data.all$id <- id


#Split data into training and testing - Assume 60,40 ratio
colnames(data.all)[4] <- 'Class'
data.all$Class <- as.factor(data.all$Class)

data.all.split <- split(data.all,data.all$Class,drop=T)
data.training<- data.frame()
data.testing <- data.frame()
#colnames(data.training) <- colnames(data.all)

for( i in 1:5){
  current <- data.frame(data.all.split[i])
  colnames(current) <- colnames(data.all)
  noSamples <- nrow(current)
  noTraining <- ceiling(0.6*noSamples)
  x2 <- sample(1:nrow(current),noTraining,replace=F)
  data.training <- rbind(data.training,current[x2,])
  data.testing <- rbind(data.testing, current[-x2,])
}

#remove X,Y, id attribute - we don't use them
data.training <- data.training[,-c(1:3)]

data.testing <- data.testing[,-c(1:3)]

colnames(data.training) <- c("Class","Aerosol","B","G","R","NIR","SWIR1","SWIR2","Cirrus")
colnames(data.testing) <- colnames(data.training)
#Write down CSV and/or arff files
data.training$Class <- as.factor(data.training$Class)
data.testing$Class <- as.factor(data.testing$Class)
write.csv(x=data.training,file=paste(fname,'-training.csv',sep=''),row.names = F)
write.arff(data.training,file=paste(fname,'-training.arff',sep=''),relation='training')

write.csv(x=data.testing,file=paste(fname,'-testing.csv',sep=''),row.names = F)
write.arff(data.testing,file=paste(fname,'-testing.arff',sep=''),relation='testing')

}


data.1 <- read.csv('../data/training/2015-04-19-AllBands-Clipped.csv') #contains all sampled points generated using

#point sampling tool in QGIS

data.2 <- read.csv('../data/training/2015-12-31-AllBands-Clipped.csv') #contains all sampled points generated using

#point sampling tool in QGIS

data.3 <- read.csv('../data/training/2016-01-16-AllBands-Clipped.csv') #contains all sampled points generated using

#point sampling tool in QGIS

x2 <- sample(1:nrow(data.1),nrow(data.1),replace=F)

splitData(data.1,x2,'../data/training/2015-04-19-AllBands-Clipped')
splitData(data.2,x2,'../data/training/2015-12-31-AllBands-Clipped')
splitData(data.3,x2,'../data/training/2016-01-16-AllBands-Clipped')
