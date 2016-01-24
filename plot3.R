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

pcData <- downloadHouseholdZip()
pcDataSub <- sanitizeData(pcData)
png("plot3.png", width=480, height=480)
par(mfrow=c(1,1))
plot(pcDataSub$Time, pcDataSub$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(pcDataSub$Time, pcDataSub$Sub_metering_2, col="red")
lines(pcDataSub$Time, pcDataSub$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), lwd=c(1, 1, 1), col=c("black", "red", "blue"))
dev.off()