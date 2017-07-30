# This script answer the following question
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.


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
total.emissions <- summarise(group_by(NEI, year), Emissions=sum(Emissions))

#create plot
png(paste0(folder,"plot1.png"), width=640, height=480)
plot(total.emissions, type = "o", main = "Total Emissions", xlab = "Year", ylab = "Emissions", pch = 20, col = "darkblue", lty = 1)
dev.off()
