# This script answers the following question
#Across the United States, how have emissions from coal combustion-related 
#sources changed from 1999-2008?


# check and create dir if needed
if (!file.exists("./data")) {dir.create("./data")}

# download file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
f <- "./data/ds.zip"
if (!file.exists("./data/ds.zip")) {download.file(url,f)}

# unzip file
if (!file.exists("./data/expanalysis")) {unzip(zipfile = f, exdir ="./data" )}

folder <- "./data/"

# read data
if(!exists("NEI")){
  NEI <- readRDS(paste0(folder,"summarySCC_PM25.rds"))
}

if(!exists("SCC")){
  SCC <- readRDS(paste0(folder,"Source_Classification_Code.rds"))
}


combustion.coal <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)
combustion.coal.sources <- SCC[combustion.coal,]

# Find emissions from coal combustion-related sources
emissions.coal.combustion <- NEI[(NEI$SCC %in% combustion.coal.sources$SCC), ]
require(dplyr)
aggregatedTotalByYear <- summarise(group_by(emissions.coal.combustion, year), Emissions=sum(Emissions))
require(ggplot2)

library(ggplot2)

png(paste0(folder,"plot4.png"), width=640, height=480)
g <- ggplot(aggregatedTotalByYear, aes(x=factor(year), Emissions/1000, fill=year))
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression("Total Emissions")) +
  ggtitle('Total Emissions from coal sources from 1999 to 2008')
print(g)
dev.off()
