downloadHouseholdZip <- function(){
  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
  pcData <- read.table(unz(temp, "household_power_consumption.txt"), sep=";", head = TRUE, stringsAsFactors = FALSE, na.string="?")
  unlink(temp)
  return(pcData)
}

sanitizeData <- function(pcData){
  library(data.table)
  pcData <- data.table(pcData)
  pcData$Date <- as.Date(pcData$Date, "%d/%m/%Y")  
  pcDataSub <- pcData[Date %between% c("2007-02-01", "2007-02-02")]
  pcDataSub$Time <- as.POSIXct(paste(pcDataSub$Date, pcDataSub$Time), format="%Y-%m-%d %H:%M:%S")
  return(pcDataSub)
}

par(mfrow=c(1,1))
pcData <- downloadHouseholdZip()
pcDataSub <- sanitizeData(pcData)
png("plot1.png", width=480, height=480)
hist(pcDataSub$Global_active_power, main="Global Active Power", xlab = "Global Active Power (kilowatts)", ylab="Frequency", col="red", ylim=c(0,1200), breaks=12)
dev.off()