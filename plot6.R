# This script answers the following question
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?


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

library(ggplot2)

#set plot data
# Baltimore, MD fips=24510 
# Los Angeles, CA fips=06037 
subsetNEI <- NEI[(NEI$fips=="24510"|NEI$fips=="06037") & NEI$type=="ON-ROAD",  ]
aggregatedTotalByYearAndFips <- aggregate(Emissions ~ year + fips, subsetNEI, sum)
aggregatedTotalByYearAndFips$fips[aggregatedTotalByYearAndFips$fips=="24510"] <- "Baltimore, MD"
aggregatedTotalByYearAndFips$fips[aggregatedTotalByYearAndFips$fips=="06037"] <- "Los Angeles, CA"

#create plog
png(paste0(folder,"plot6.png"), width=640, height=480)
g <- ggplot(aggregatedTotalByYear, aes(factor(year), y=Emissions,fill=year))
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression("Total Emissions")) +
  ggtitle('Motor vehicle emission variation in Baltimore and Los Angeles from 1999 to 2008')
print(g)
dev.off()
