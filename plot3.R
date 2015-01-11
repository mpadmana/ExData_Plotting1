rowsInEachIter=100000
dataset <- read.table("household_power_consumption.txt", header = TRUE, sep=";", nrows = rowsInEachIter, na.strings = "?")
columns<-colnames(dataset)
dataset$DateToFilter <- as.Date(dataset$Date, format="%d/%m/%Y") 
get.rows <- dataset$DateToFilter == as.Date("2007-02-01") | dataset$DateToFilter == as.Date("2007-02-02")
dataset<-dataset[get.rows,]

iter=1

repeat{
    fromRow=iter*rowsInEachIter
    datasetTemp<-read.table("household_power_consumption.txt", header = TRUE, sep=";", skip=fromRow, nrows=rowsInEachIter, na.strings = "?", col.names = columns)
    datasetTemp$DateToFilter <- as.Date(datasetTemp$Date, format="%d/%m/%Y") 
    get.rows <- datasetTemp$DateToFilter == as.Date("2007-02-01") | datasetTemp$DateToFilter == as.Date("2007-02-02")
    dataset<-rbind(dataset, datasetTemp[get.rows,])
    if (nrow(datasetTemp) < rowsInEachIter){
        break
    }
    rm(datasetTemp)
    iter=iter+1    
}   



png(filename = "plot3.png", width = 480, height = 480, units = "px")
na.omit(dataset)
dataset$DateTime <- as.POSIXct(paste(dataset$Date, dataset$Time), format="%d/%m/%Y %H:%M:%S") 
plot(dataset$DateTime,dataset$Sub_metering_1,xlab="", ylab="Energy sub metering", type="l")
points(dataset$DateTime,dataset$Sub_metering_2,type="l",col=2)
points(dataset$DateTime,dataset$Sub_metering_3,type="l",col=4)
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c(1,2,4), lwd=1)

dev.off()