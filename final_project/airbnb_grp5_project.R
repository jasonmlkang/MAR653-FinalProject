
#title: AirBnB Group Project 
#author:  Group 5 project team: Thomas Bahng, Toni Hanrahan, Jason Kang, Michael Man 
#date: Mar 15, 2020 
#______________________________________________


#Step 0: install packages

#install.packages("arsenal")
#install.packages("arules")
#install.packages("cluster")
#install.packages("factoextra")
#install.packages("ggplot2")
#install.packages("infotheo")
#install.packages("knitr")
#install.packages("matrix")
#install.packages("mclust") 
#install.packages("plyr") 
#install.packages("proxy")
#install.packages("quanteda")
#install.packages("rattle")
#install.packages("RColorBrewer")
#install.packages("readr")
#install.packages("rpart")
#install.packages("rpart.plot")
#install.packages("RWeka")
#install.packages("slam")
#install.packages("Snowball")
#install.packages("Snowballc")
#install.packages("stringr")
#install.packages("tidytext")
#install.packages("tm")
#install.packages("wordcloud")
library(arsenal)
library(arules)
library(cluster)
library(factoextra) # for fviz
library(ggplot2)
library(infotheo)
library(knitr)
library(Matrix)
library(mclust) # for Mclust EM clustering
library(plyr) ## for adply
library(dplyr)
library(proxy)
library(quanteda)
library(rattle)
library(RColorBrewer)
library(readr)
library(rpart)
library(rpart.plot)
library(RWeka)
library(slam)
library(Snowball)
library(SnowballC)
library(stringi)
library(tidytext) # convert DTM to DF
library(tm)
library(wordcloud)



#Step 1: Load the data 
#listings = read.csv("~/R/thanrahan_scripts/MAR653/listings.csv/listings.csv", stringsAsFactors=FALSE, header = TRUE)


base_list2 <- read.csv("~/R/thanrahan_scripts/MAR653/listings_cleaned.csv", stringsAsFactors=FALSE, header = TRUE)


#1.2 Remove columns that will get in the way of clustering 
## Keep columns with categorical variables
#base_list <- listings[,c(23:24, 26:29, 32:34, 36:58, 60:65, 67:106)]

#head(base_list, n= 6)
#str(base_list)

distinct(base_list2, neighbourhood_group_cleansed)

#neighbourhood_group_cleansed
#1                    Manhattan
#2                     Brooklyn
#3                       Queens
#4                Staten Island
#5                        Bronx

base_list3 <- base_list2[,c(8, 13, 16, 22:25, 27, 43:44, 47:53, 65, 67:72)]
base_list3[is.na(base_list3)] <- 0
base_list3$neighbourhood_group_cleansed[base_list3$neighbourhood_group_cleansed == "Manhattan"] <- 1
base_list3$neighbourhood_group_cleansed[base_list3$neighbourhood_group_cleansed == "Brooklyn"] <- 2
base_list3$neighbourhood_group_cleansed[base_list3$neighbourhood_group_cleansed == "Queens"] <- 3
base_list3$neighbourhood_group_cleansed[base_list3$neighbourhood_group_cleansed == "Staten Island"] <- 4
base_list3$neighbourhood_group_cleansed[base_list3$neighbourhood_group_cleansed == "Bronx"] <- 5

base_list3 <- as.data.frame(apply(base_list3, 2, as.numeric)) 
base_list3[is.na(base_list3)] <- 0
str(base_list3)



###############################
#k means with 6 clusters
###############################



##k - means in r  
k = 6  ## choose the number of clusters, start with 6 but try different values
kmeansModel <- kmeans(base_list3, k)

## Get the clusters that were assigned to each group
clusterGroups <- data.frame(base_list3,kmeansModel$cluster)
## NOTE: the "V" in view must be cap (not lowercase)
View(clusterGroups)

## plot the clusters
plot(base_list3$host_total_listings~ jitter(kmeansModel$cluster, 1),
     pch=21,col=as.factor(base_list3$accomodate))


## use PCA (prin comp analysis) to reduce the Dim to view the clusters
clusplot(base_list3, kmeansModel$cluster,color=TRUE,
         shade=TRUE, labels=4, lines=0, main="Principal Characteristics of Cluster Analysis")


#Good graph!!
ClusterGraph4 <- ggplot(clusterGroups) + geom_jitter(aes(kmeansModel.cluster, neighbourhood_group_cleansed, color = kmeansModel.cluster))  + ggtitle("Cluster by Neighborhood") + scale_x_continuous(breaks=1:6,labels=c("1","2","3","4","5","6")) + scale_y_continuous(breaks=1:5,labels=c("Manhattan","Brooklyn","Queens","Staten Island","Bronx")) + xlab("Cluster") + ylab("Neighborhood")
ClusterGraph4

#another Good graph!!
ClusterGraph5 <- ggplot(clusterGroups) + geom_jitter(aes(kmeansModel.cluster, price, color = kmeansModel.cluster))  + ggtitle("Cluster by Price") + scale_x_continuous(breaks=1:6,labels=c("1","2","3","4","5","6")) +  xlab("Cluster") + ylab("Price")
ClusterGraph5

#another Good graph!!
ClusterGraph6 <- ggplot(clusterGroups) + geom_jitter(aes(kmeansModel.cluster, review_scores_rating, color = kmeansModel.cluster))  + ggtitle("Cluster by Overall Review Rating") + scale_x_continuous(breaks=1:6,labels=c("1","2","3","4","5","6")) +  xlab("Cluster") + ylab("Rating")
ClusterGraph6

#another Good graph!!
ClusterGraph7 <- ggplot(clusterGroups) + geom_jitter(aes(kmeansModel.cluster, review_scores_cleanliness, color = kmeansModel.cluster))  + ggtitle("Cluster by Cleanliness Rating") + scale_x_continuous(breaks=1:6,labels=c("1","2","3","4","5","6")) +  xlab("Cluster") + ylab("Rating")
ClusterGraph7

#another Good graph!!
ClusterGraph8 <- ggplot(clusterGroups) + geom_jitter(aes(kmeansModel.cluster, review_scores_accuracy, color = kmeansModel.cluster))  + ggtitle("Cluster by Accuracy Rating") + scale_x_continuous(breaks=1:6,labels=c("1","2","3","4","5","6")) +  xlab("Cluster") + ylab("Rating")
ClusterGraph8

#another Good graph!!
ClusterGraph9 <- ggplot(clusterGroups) + geom_jitter(aes(review_scores_cleanliness, review_scores_accuracy, color = kmeansModel.cluster))  + ggtitle("Cleanliness and Accuracy Rating by Cluster") +   xlab("Cleanliness Rating") + ylab("Accuracy Rating")
ClusterGraph9

#another Good graph!!
ClusterGraph10 <- ggplot(clusterGroups) + geom_jitter(aes(neighbourhood_group_cleansed, price, color = kmeansModel.cluster))  + ggtitle("Neighborhood and Price by Cluster") + scale_x_continuous(breaks=1:5,labels=c("Manhattan","Brooklyn","Queens","Staten Island","Bronx")) +  xlab("Neighborhood") + ylab("Price") + ylim(0, 2000)
ClusterGraph10

#another Good graph!!
ClusterGraph11 <- ggplot(clusterGroups) + geom_jitter(aes(prizm_cluster, review_scores_rating, color = kmeansModel.cluster))  + ggtitle("Rating and Prizm by Cluster") +   xlab("Prizm Cluster") + ylab("Rating") + ylim(75, 100)
ClusterGraph11

#another Good graph!!
ClusterGraph12 <- ggplot(clusterGroups) + geom_jitter(aes(prizm_cluster, kmeansModel.cluster, color = kmeansModel.cluster))  + ggtitle("Prizm by Cluster") +   xlab("Prizm") + ylab("Cluster") 
ClusterGraph12

#another Good graph!!
ClusterGraph13 <- ggplot(clusterGroups) + geom_jitter(aes(neighbourhood_group_cleansed, kmeansModel.cluster, color = kmeansModel.cluster))  + ggtitle("Neighborhood by Cluster") +   xlab("Neighborhood") + ylab("Cluster") + scale_x_continuous(breaks=1:5,labels=c("Manhattan","Brooklyn","Queens","Staten Island","Bronx"))
ClusterGraph13







###############################
#Try again with fewer variables
###############################


base_list4 <- base_list3[,c(2,4,8,11:18)]



##k - means in r  
k = 5  ## choose the number of clusters, start with 6 but try different values
kmeansModel2 <- kmeans(base_list4, k)

## Get the clusters that were assigned to each group
clusterGroups2 <- data.frame(base_list4,kmeansModel2$cluster)
## NOTE: the "V" in view must be cap (not lowercase)
#View(clusterGroups)



## use PCA (prin comp analysis) to reduce the Dim to view the clusters
clusplot(base_list4, kmeansModel2$cluster,color=TRUE,
         shade=TRUE, labels=4, lines=0, main="Principal Characteristics of Cluster Analysis")





###############################
#Final graphs to use
###############################

#Good graph!!  Cluster by Neighborhood
ClusterGraph14 <- ggplot(clusterGroups2) + geom_jitter(aes(kmeansModel2.cluster, neighbourhood_group_cleansed, color = kmeansModel2.cluster))  + ggtitle("Cluster by Neighborhood") + scale_y_continuous(breaks=1:5,labels=c("Manhattan","Brooklyn","Queens","Staten Island","Bronx")) + xlab("Cluster") + ylab("Neighborhood")
ClusterGraph14

#another Good graph!!  Cluster by Price
ClusterGraph15 <- ggplot(clusterGroups2) + geom_jitter(aes(kmeansModel2.cluster, price, color = kmeansModel2.cluster))  + ggtitle("Cluster by Price") +  xlab("Cluster") + ylab("Price") 
ClusterGraph15

#another Good graph!!  Cluster by Overall Review Rating
ClusterGraph16 <- ggplot(clusterGroups2) + geom_jitter(aes(kmeansModel2.cluster, review_scores_rating, color = kmeansModel2.cluster))  + ggtitle("Cluster by Overall Review Rating") +   xlab("Cluster") + ylab("Rating") + ylim(25,100)
ClusterGraph16

#another Good graph!!  Cluster by Cleanliness Rating
ClusterGraph17 <- ggplot(clusterGroups2) + geom_jitter(aes(kmeansModel2.cluster, review_scores_cleanliness, color = kmeansModel2.cluster))  + ggtitle("Cluster by Cleanliness Rating") +   xlab("Cluster") + ylab("Rating") + ylim(1,10)
ClusterGraph17

#another Good graph!!  Cluster by Accuracy Rating
ClusterGraph18 <- ggplot(clusterGroups2) + geom_jitter(aes(kmeansModel2.cluster, review_scores_accuracy, color = kmeansModel2.cluster))  + ggtitle("Cluster by Accuracy Rating") +  xlab("Cluster") + ylab("Rating") + ylim(1,10)
ClusterGraph18

#another Good graph!!  Cleanliness and Accuracy Rating by Cluster
ClusterGraph19 <- ggplot(clusterGroups2) + geom_jitter(aes(review_scores_cleanliness, review_scores_accuracy, color = kmeansModel2.cluster))  + ggtitle("Cleanliness and Accuracy Rating by Cluster") +   xlab("Cleanliness Rating") + ylab("Accuracy Rating") + xlim(1,10) + ylim(1,10)
ClusterGraph19

#another Good graph!!  Neighborhood and Price by Cluster
ClusterGraph20 <- ggplot(clusterGroups2) + geom_jitter(aes(neighbourhood_group_cleansed, price, color = kmeansModel2.cluster))  + ggtitle("Neighborhood and Price by Cluster") + scale_x_continuous(breaks=1:5,labels=c("Manhattan","Brooklyn","Queens","Staten Island","Bronx")) +  xlab("Neighborhood") + ylab("Price") + ylim(0, 2000)
ClusterGraph20

#another Good graph!!  Rating and Prizm by Cluster
ClusterGraph21 <- ggplot(clusterGroups2) + geom_jitter(aes(prizm_cluster, review_scores_rating, color = kmeansModel2.cluster))  + ggtitle("Rating and Prizm by Cluster") +   xlab("Prizm Cluster") + ylab("Rating") + ylim(75, 100)
ClusterGraph21

#another Good graph!!  Prizm by Cluster
ClusterGraph22 <- ggplot(clusterGroups2) + geom_jitter(aes(prizm_cluster, kmeansModel2.cluster, color = kmeansModel2.cluster))  + ggtitle("Prizm by Cluster") +   xlab("Prizm") + ylab("Cluster") 
ClusterGraph22

#another Good graph!!  Neighborhood by Cluster
ClusterGraph23 <- ggplot(clusterGroups2) + geom_jitter(aes(neighbourhood_group_cleansed, kmeansModel2.cluster, color = kmeansModel2.cluster))  + ggtitle("Neighborhood by Cluster") +   xlab("Neighborhood") + ylab("Cluster") + scale_x_continuous(breaks=1:5,labels=c("Manhattan","Brooklyn","Queens","Staten Island","Bronx"))
ClusterGraph23

#another Good graph!!  Rating and Price by Cluster
ClusterGraph24 <- ggplot(clusterGroups2) + geom_jitter(aes(review_scores_rating, price, color = kmeansModel2.cluster))  + ggtitle("Rating and Price by Cluster") +   xlab("Rating") + ylab("Price") + ylim(0, 2000) + xlim(20,100)
ClusterGraph24



####################################
#list the centroids of each variable
####################################

cluster_summary <- as.data.frame(aggregate(clusterGroups2, by=list(kmeansModel2.cluster=kmeansModel2$cluster), mean))
head(cluster_summary)
str(cluster_summary)

table(clusterGroups2$kmeansModel2.cluster)



cluster4 <- clusterGroups2[which(clusterGroups2$kmeansModel2.cluster == 4),names(clusterGroups2) %in% c("neighbourhood_group_cleansed",	"accommodates",	"price", 	"review_scores_rating",	"review_scores_accuracy",	"review_scores_cleanliness",	"review_scores_checkin",	"review_scores_communication",	"review_scores_location",	"review_scores_value",	"prizm_cluster")]
cluster4


