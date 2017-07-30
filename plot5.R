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

require(ggplot2)
subsetNEI <- NEI[NEI$fips=="24510" & NEI$type=="ON-ROAD",  ]
aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEI, sum)

png(paste0(folder,"plot5.png"), width=640, height=480)
g <- ggplot(aggregatedTotalByYear, aes(factor(year), y=Emissions,fill=year))
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression("Total Emissions")) +
  ggtitle('Emissions from motor vehicle sources changed from 1999-2008 in Baltimore City')
print(g)
dev.off()
