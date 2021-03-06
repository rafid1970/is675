##################################################
# libraries
##################################################
library(fpc)

##################################################
# K-means
##################################################
protein <- read.csv("protein.csv", stringsAsFactors = FALSE)
str(protein)

pro.sources <- protein[2:10]
summary(pro.sources)

pro.sources_z <- as.data.frame(lapply(pro.sources, scale))
summary(pro.sources_z)

set.seed(123)
protein.clusters <- kmeans(pro.sources_z, 4)
protein.clusters

protein.clusters$size
protein.clusters$centers

protein$cluster <- protein.clusters$cluster

protein[, c("cluster","Country")]

protein[which(protein$cluster == 4), c("cluster","Country")]

str(protein)

aggregate(data = protein, RedMeat ~ cluster, mean)
aggregate(data = protein, Milk ~ cluster, mean)
aggregate(data = protein, Eggs ~ cluster, mean)

aggregate(data = protein, Nuts ~ cluster, mean)
aggregate(data = protein, Fish ~ cluster, mean)
aggregate(data = protein, Starch ~ cluster, mean)

plotcluster(protein[2:10], protein$cluster)