# R Script to create first plot

# Read in only the rows for the dates 2007-02-01 and 2007-02-02
# (I looked up the line numbers with the vim editor in terminal)
# First, however, read in the variable names

file1 <- "household_power_consumption.txt"

variables <- read.table( file1, header = TRUE, nrows = 1, sep = ";" )
variables <- names(variables)
power_df <- read.table( file1, skip = 66637, nrows = 2880, sep = ";", col.names = variables, na.strings = "?" )

#NOTE: before proceeding, I checked for any NA values using 
# apply(power_df, 2, function(x) any(is.na(x))). There were 
# no missing values in this subset. 

# Create the plot
hist(power_df$Global_active_power, yaxt = 'n', col = "red", main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)" )

axis(2, at = seq( 0, 1200, 200 ) )

dev.copy( png, file = "plot1.png")
dev.off()

