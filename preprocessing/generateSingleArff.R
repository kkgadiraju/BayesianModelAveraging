#convert geotiff to csv/arff format to be used in Weka classifiers
#Krishna Karthik Gadiraju/kkgadiraju
rm(list=ls())

library(rgdal)
library(rgeos)
library(foreign)



myImg<-readGDAL('../training/2016-01-16-AllBands-Clipped.tif')
myImgData <- myImg@data
colnames(myImgData) <- c("Aerosol","B","G","R","NIR","SWIR1","SWIR2","Cirrus")
allData <- myImgData


x2 <- sample(1:5,nrow(allData),replace=T)
allData$Class <-x2
outputData <- allData
outputData$Class <- as.factor(outputData$Class)

outputData <- outputData[,c("Class","Aerosol","B","G","R","NIR","SWIR1","SWIR2","Cirrus")]
write.csv(x=outputData,file = '../training/2016-01-16-AllBands.csv',row.names = F)
write.arff(outputData,file='../training/2016-01-16-AllBands.arff',relation='testing')

