# Load Fish/ amphibian data from Barb Beasley
(wd <- getwd()) #Desktop, Git Hub, Fish-Amphibians
amp <- read.csv("Fish Amphibian 2012 for Alicia.csv", stringsAsFactors = TRUE)
str(amp)

#how many sites are there?

length(unique(amp$Site))
#uh oh there are only supposed to be 6.
#Find the blank one
(bad <- amp[amp$Site == "", ]) #1114
#Great, looks like we can delete it because it was just a copying error
amps <- amp[1:1113, ]
str(amps)
length(unique(amps$Site)) # 6!!

row.with.levels <- rep(NA, 10)

for(i in 2:length(levels(amps$Site))){
  row.with.error <- grep(levels(amps$Site)[i], amp$Site)
}


# Rename the sites for simplicity
amps$sites

# amps$Site <- replace(levels(amps$Site), c("","A", "B", "C", "D", "E", "F"))
list(amps$Site)
?replace
xt <- factor(amps$Site)
str(xt)
levels(xt)
(levels(xt) <- c("A", "B", "C", "D", "E", "F"))
amps$site <- (levels(xt) <- c("A", "B", "C", "D", "E", "F"))
