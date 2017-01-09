#!/bin/bash

#compile java code
javac -cp weka.jar UrbanClassification.java

f11="../training/2015-04-19-AllBands-Clipped-training.arff"
f12="../training/2015-04-19-AllBands.arff"
f21="../training/2015-12-31-AllBands-Clipped-training.arff"
f22="../training/2015-12-31-AllBands.arff"
f31="../training/2016-01-16-AllBands-Clipped-training.arff"
f32="../training/2016-01-16-AllBands.arff"
f41="../training/2016-03-20-AllBands-Clipped-training.arff"
f42="../training/2016-03-20-AllBands.arff"

#run classifiers
java -cp weka.jar:. UrbanClassification  $f11 $f12 "nbayes"

wait


java -cp weka.jar:. UrbanClassification  $f11 $12 "j48"

wait


java -cp weka.jar:. UrbanClassification  $f11 $f12 "randomForest"

wait


java -cp weka.jar:. UrbanClassification  $f11 $f12 "mlp"

wait


java -cp weka.jar:. UrbanClassification  $f11 $f12 "knn"

wait

#run classifiers
java -cp weka.jar:. UrbanClassification  $f21 $f22 "nbayes"

wait


java -cp weka.jar:. UrbanClassification  $f21 $22 "j48"

wait


java -cp weka.jar:. UrbanClassification  $f21 $f22 "randomForest"

wait


java -cp weka.jar:. UrbanClassification  $f21 $f22 "mlp"

wait


java -cp weka.jar:. UrbanClassification  $f21 $f22 "knn"


wait


#run classifiers
java -cp weka.jar:. UrbanClassification  $f31 $f32 "nbayes"

wait


java -cp weka.jar:. UrbanClassification  $f31 $32 "j48"

wait


java -cp weka.jar:. UrbanClassification  $f31 $f32 "randomForest"

wait


java -cp weka.jar:. UrbanClassification  $f31 $f32 "mlp"

wait


java -cp weka.jar:. UrbanClassification  $f31 $f32 "knn"

wait  

#run classifiers
java -cp weka.jar:. UrbanClassification  $f41 $f42 "nbayes"

wait


java -cp weka.jar:. UrbanClassification  $f41 $42 "j48"

wait


java -cp weka.jar:. UrbanClassification  $f41 $f42 "randomForest"

wait


java -cp weka.jar:. UrbanClassification  $f41 $f42 "mlp"

wait


java -cp weka.jar:. UrbanClassification  $f41 $f42 "knn"

wait
