# R Script to create first plot

# Read in only the rows for the dates 2007-02-01 and 2007-02-02
# (I looked up the line numbers with the vim editor in terminal)
# First, however, read in the variable names

file1 <- "household_power_consumption.txt"

variables <- read.table( file1, header = TRUE, nrows = 1, sep = ";" )
variables <- names(variables)
power_df <- read.table( file1, skip = 66637, nrows = 2880, sep = ";", 
                        col.names = variables, na.strings = "?" )

# combine the first two columns
power_df <- mutate( power_df, time_series = paste( Date, Time ) )

# now the first two columns are superfluous, so remove them
power_df <- select( power_df, -c( Date, Time ) )

# next, convert new column to POSIXct 
power_df <- mutate( power_df, time_series = 
                    as.POSIXct( time_series, format = "%d/%m/%Y %H:%M:%S" ) ) 

# Create the plot
ylabel <- "Global Active Power (kilowatts)"

with( power_df, plot( time_series, Global_active_power, 
                      ylab = ylabel, xlab = "", type = "l" ) )

dev.copy( png, file = "plot2.png")
dev.off()

