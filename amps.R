#=========== Code for Barb Beasley's 2012 data on fish/amphibians==========

#------Load and fix the data------
# Load Fish/ amphibian data from Barb Beasley
(wd <- getwd()) #Desktop, Git Hub, Fish-Amphibians
amp <- read.csv("Fish Amphibian 2012 for Alicia.csv", stringsAsFactors = TRUE)
str(amp)

#how many sites are there?
unique(amp$Site)
length(unique(amp$Site))
#uh oh there are only supposed to be 6.
#Find the blank one shown in unique()
(bad <- amp[amp$Site == "", ]) #1114
#Great, looks like we can delete the last row because it was just a copying error
amps <- amp[-(nrow(amp)), ] #delete the last row and all it's columns
str(amps)
unique(amps$Site)
length(unique(amps$Site)) # 6!! Now we can just use "amps"
table(amps$Site) #blank is still there but not occuring, so use unique()

##not working? remove the next "#" to...
#rm(list = ls()) #clear the working memory then...
#re run everything above.##

#Get rid of some columns
colnames(amps)
amp1 <- amp[-(nrow(amp)), c(1, 17)]
str(amp1)

#------Split up the data and analysis-----
#separate the data per site
unique(amp1$Site) #gives you the index numbers
name <- unique(amp1$Site)
(s1 <- amp1[grep(name[1], amp1$Site), ])
(s2 <- amp1[grep(name[2], amp1$Site), ])
(s3 <- amp1[grep(name[3], amp1$Site), ])
(s4 <- amp1[grep(name[4], amp1$Site), ])
(s5 <- amp1[grep(name[5], amp1$Site), ])
(s6 <- amp1[grep(name[6], amp1$Site), ])

#Make tables for each sites, to see how many individuals in each spp
View(table(s1$Spp))
View(table(s2$Spp))
View(table(s3$Spp))
View(table(s4$Spp))
View(table(s5$Spp))
View(table(s6$Spp))
#Count # of species present (out of 30 total spp)
length(unique(s1$Spp)) #14
length(unique(s2$Spp)) #18
length(unique(s3$Spp)) #11
length(unique(s4$Spp)) #14
length(unique(s5$Spp)) #14
length(unique(s6$Spp)) #15

# Run diversity indices
# http://rstudio-pubs-static.s3.amazonaws.com/11473_29c2de401c55441ca5350862ebd04456.html
install.packages("vegan")
library(vegan)
install.packages("Hotelling")
library(Hotelling)
?vegan::diversity # Gives you the format
diversity(table(s1$Spp), index = "shannon") #1.490609
diversity(table(s2$Spp), index = "shannon") #2.331664
diversity(table(s3$Spp), index = "shannon") #1.839112
diversity(table(s4$Spp), index = "shannon") #1.630797
diversity(table(s5$Spp), index = "shannon") #1.274444
diversity(table(s6$Spp), index = "shannon") #2.043437


#Now we need to make a new column for the higher taxon groups to...
# which each species belongs



#--------- Rename the sites for simplicity #needs work--------
amp1$sites

replace(unique(amp1$Site), c("A", "B", "C", "D", "E", "F"))
?replace
xt <- factor(amp1$Site)
str(xt)
levels(xt)
(levels(xt) <- c("A", "B", "C", "D", "E", "F"))
amp1$site <- (levels(xt) <- c("A", "B", "C", "D", "E", "F"))
