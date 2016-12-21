#
#
#
#=========== Code for Barb Beasley's 2012 data on fish/amphibians==========
#
#
#

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
length(unique(s1$Spp)) #13
length(unique(s2$Spp)) #18
length(unique(s3$Spp)) #11
length(unique(s4$Spp)) #13
length(unique(s5$Spp)) #11
length(unique(s6$Spp)) #15

# Run diversity indices
# http://rstudio-pubs-static.s3.amazonaws.com/11473_29c2de401c55441ca5350862ebd04456.html
install.packages("vegan")
library(vegan)
install.packages("Hotelling")
library(Hotelling)
?vegan::diversity # Gives you the format
(d1<-diversity(table(s1$Spp), index = "shannon")) #1.454809
(d2<-diversity(table(s2$Spp), index = "shannon")) #2.331664
(d3<-diversity(table(s3$Spp), index = "shannon")) #1.839112
(d4<-diversity(table(s4$Spp), index = "shannon")) #1.588462
(d5<-diversity(table(s5$Spp), index = "shannon")) #1.274444
(d6<-diversity(table(s6$Spp), index = "shannon")) #2.043437

#----- Taxon Loop-----
#Now we need to make a new column for the higher taxon groups to...
# which each species belongs

#Make empty column
amp1$taxa <- rep(NA, length(amp1$Site))

#to see the index numbers for each spp
unique(amp1$Spp)

#We have 4 amp spp: RAAU, AMGR, TAGR, HYRE
#This gives you all the rows with RAAU or (|) AMGR or...
all.amps <- grep("RAAU|AMGR|TAGR|HYRE", amp1$Spp)
#Now fill in the "NA"s with "Amphibian"
amp1$taxa[c(all.amps)] <- "Amphibian"
# check
amp1$taxa  #YEP!

#Repeat for 4 Fish spp: TSB, CCT, CO, SCULPIN
all.fish <- grep("TSB|CCT|CO|SCULPIN", amp1$Spp)
#Fill in "NA"s with "Fish"
amp1$taxa[c(all.fish)] <- "Fish"
# check
View(amp1) #YA!!

#Make table with taxa in rows and sites at top
(table0 <- table(amp1$Spp, amp1$Site))
# So there is 3 sites with/without Trout, but only 1 (Swan Lake) without Trout or COHO
(table <- table(amp1$taxa, amp1$Site))
(table <- table[ , -c(1)]) #to get rid of the first 00 column
#Swan lake has the most Amphibians!

#export table to CSV file in the folder "data"
write.csv(table0, file = paste(wd, "/data/", "Spp.Site.csv", sep = ""))
write.csv(table, file = paste(wd, "/data/", "taxa.Site.csv", sep = ""))

#Look at the diversity of Amps only per site
(d1<-diversity(table(s1$Spp), index = "shannon")) #1.454809
(d2<-diversity(table(s2$Spp), index = "shannon")) #2.331664
(d3<-diversity(table(s3$Spp), index = "shannon")) #1.839112
(d4<-diversity(table(s4$Spp), index = "shannon")) #1.588462
(d5<-diversity(table(s5$Spp), index = "shannon")) #1.274444
(d6<-diversity(table(s6$Spp), index = "shannon")) #2.043437
merge(table0, table, by=c("", "BlackHole", "LS2B", "LS3A", "LS4", "Swan Lake", "Wood Lake - LS3C"))

#Lets look at the distribution of Amphibian abundance vs Fish abundance per site.
plot(table[2, ], table[1, ], xlab = "Amphibian Abundance", ylab = "Fish Abundance", 
     las = 1, col = "Purple3", pch = 16, xlim = c(0, 120), ylim = c(0, 200))

#ANOVA
m0 <- lm(table[2, ] ~ 1)
m1 <- lm(table[2, ] ~ table[1, ]) 

#plot the fitted line
abline(m1, col = "Red")

#find the variance
(rs.sq.m0 <- sum(m0$residuals^2)) #5579.333

#use the same measure as above to check id more or less variance
(rs.sq.m1 <- sum(m1$residuals^2)) #5220.094
#That means that m1 = 5220 is a slightly better fit then the null model (m0) = 5579

anova(m0, m1)
#Analysis of Variance Table
#Model 1: table[2, ] ~ 1
#Model 2: table[2, ] ~ table[1, ]
#Res.Df    RSS Df Sum of Sq      F Pr(>F)
#1      5 5579.3                           
#2      4 5220.1  1    359.24 0.2753 0.6275



