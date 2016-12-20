#
#
#
#=========== Code for Barb Beasley's 2012 data on fish/amphibians==========
#
#
#

getwd()
path.to.data <- paste(wd, "/data/", sep = "")
data.file.names <- list.files( paste(wd, "/data/", sep = ""))

d <- read.csv(paste(path.to.data, data.file.names, sep = ""), stringsAsFactors = FALSE)
write.csv(d, paste(path.to.data, "new.data.csv", sep = ""))



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

#Check that all the spps names are right
unique(amp1$Spp)
#There are some weird ones: RAAUDEAD, NONE, CODEAD
#How many are there? 
table(amp1$Spp) #looks like they are important except NONE (0)
#What row (index #) are they in?
grep("RAAUDEAD", amp1$Spp) #100
grep("CODEAD", amp1$Spp) #441, 565

#Change the names to just their species
amp1$Spp[100] <- "RAAU"
amp1$Spp[c(441, 565)] <- "CO"
#Check that it worked
table(amp1$Spp) #Yep the CODEAD #s and RAAU #s went to CO and RAAU respectively

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
(d1<-diversity(table(s1$Spp), index = "shannon")) #1.490609
(d2<-diversity(table(s2$Spp), index = "shannon")) #2.331664
(d3<-diversity(table(s3$Spp), index = "shannon")) #1.839112
(d4<-diversity(table(s4$Spp), index = "shannon")) #1.630797
(d5<-diversity(table(s5$Spp), index = "shannon")) #1.274444
(d6<-diversity(table(s6$Spp), index = "shannon")) #2.043437

#not nessary or helpful
hist(cbind(d1,d2,d3,d4,d5,d6), breaks = 3)

#----- Taxon Loop-----
#Now we need to make a new column for the higher taxon groups to...
# which each species belongs

#Make empty column
amp1$taxa <- rep(NA, length(amp1$Site))

#to see the 
unique(amp1$Spp)


#Make a Loop... not done
for(i in 1:length(amp1$Site)){
  print(i) #to check for errors but not needed. 
  # Also i <- 42 # to check where (42) it goes wrong
  sample.A <- sample(d$value[d$group == "A"], n.A, replace = TRUE)
  sample.B <- sample(d$value[d$group == "B"], n.B, replace = TRUE)
  store.means[i] <- mean(sample.A) - mean(sample.B) #stores values in empty vector
  #diff.means <- mean(sample.A) - mean(sample.B) #longer way
  #store.means <- diff.means
}


#--------- Rename the sites for simplicity #needs work--------
amp1$sites

replace(unique(amp1$Site), c("A", "B", "C", "D", "E", "F"))
?replace
xt <- factor(amp1$Site)
str(xt)
levels(xt)
(levels(xt) <- c("A", "B", "C", "D", "E", "F"))
amp1$site <- (levels(xt) <- c("A", "B", "C", "D", "E", "F"))
