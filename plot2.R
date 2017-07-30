# This script answer the following question
#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.


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

require(dplyr)
# aggregagte data by year
balt.emissions<-summarise(group_by(filter(NEI, fips == "24510"), year), Emissions=sum(Emissions))

#create plot
png(paste0(folder,"plot2.png"), width=640, height=480)
plot(balt.emissions, type = "o", main = "Total Emissions in Baltimore County", xlab = "Year", ylab = "Emissions", pch = 18, col = "darkgreen", lty = 5)
dev.off()
