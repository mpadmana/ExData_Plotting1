rowsInEachIter=100000
dataset <- read.table("household_power_consumption.txt", header = TRUE, sep=";", nrows = rowsInEachIter, na.strings = "?")
columns<-colnames(dataset)
dataset$DateToFilter <- as.Date(dataset$Date, format="%d/%m/%Y") 
get.rows <- dataset$DateToFilter == as.Date("2007-02-01") | dataset$DateToFilter == as.Date("2007-02-02")
dataset<-dataset[get.rows,]

iter=1

repeat{
    fromRow=iter*rowsInEachIter
    datasetTemp<-read.table("household_power_consumption.txt", header = TRUE, sep=";", skip=fromRow, nrows=rowsInEachIter, col.names = columns, na.strings = "?")
    datasetTemp$DateToFilter <- as.Date(datasetTemp$Date, format="%d/%m/%Y") 
    get.rows <- datasetTemp$DateToFilter == as.Date("2007-02-01") | datasetTemp$DateToFilter == as.Date("2007-02-02")
    dataset<-rbind(dataset, datasetTemp[get.rows,])
    if (nrow(datasetTemp) < rowsInEachIter){
        break
    }
    rm(datasetTemp)
    iter=iter+1    
}   



png(filename = "plot2.png", width = 480, height = 480, units = "px")
na.omit(dataset)
dataset$DateTime <- as.POSIXct(paste(dataset$Date, dataset$Time), format="%d/%m/%Y %H:%M:%S") 
plot(dataset$DateTime, dataset$Global_active_power, ylab = "Global Active Power (kilowatts)", xlab = " ", type = "l")

dev.off()