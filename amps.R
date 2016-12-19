# Load Fish/ amphibian data from Barb Beasley
(wd <- getwd()) #Desktop, Git Hub, Fish-Amphibians
amp <- read.csv("Fish Amphibian 2012 for Alicia.csv", stringsAsFactors = TRUE)
str(amp)

#how many sites are there?
unique(amp$Site)
length(unique(amp$Site))
#uh oh there are only supposed to be 6.
#Find the blank one
(bad <- amp[amp$Site == "", ]) #1114
#Great, looks like we can delete it because it was just a copying error
amp1 <- amp[1:1113, ]
str(amp1)
?drop
amps <- amp[-(nrow(amp)), ]
str(amps)
unique(amps$Site)
length(unique(amps$Site)) # 6!!

remove(amps)
#Git rid of some colums
colnames(amps)
amps <- amp[1:1113, c(1, 17)]
str(amps)

(s1 <- amps[amps$Sites == "LS4", ])
(s2 <- amps[amps$Sites == "Wood Lake - LS3C", ])
#count number of species in each site
s1 <- 

# Rename the sites for simplicity
amps$sites

replace(unique(amps$Site), c("A", "B", "C", "D", "E", "F"))
?replace
xt <- factor(amps$Site)
str(xt)
levels(xt)
(levels(xt) <- c("A", "B", "C", "D", "E", "F"))
amps$site <- (levels(xt) <- c("A", "B", "C", "D", "E", "F"))
