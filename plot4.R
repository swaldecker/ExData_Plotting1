# R Script to create first plot

# load packages
library(tidyr)
library(dplyr)

#--------------------Create Tidy Data Set---------------------------

# Read in only the rows for the dates 2007-02-01 and 2007-02-02
# (I looked up the line numbers with the vim editor in terminal)
# First, however, read in the variable names

file1 <- "household_power_consumption.txt"

variables <- read.table( file1, header = TRUE, nrows = 1, sep = ";" )
variables <- names(variables)
df <- read.table( file1, skip = 66637, nrows = 2880, sep = ";", 
                  col.names = variables, na.strings = "?" )

# combine the first two columns
df <- mutate( df, time_series = paste( Date, Time ) )

# now the first two columns are superfluous, so remove them
df <- select( df, -c( Date, Time ) )

# next, convert new column to POSIXct 
df <- mutate( df, time_series = 
              as.POSIXct( time_series, format = "%d/%m/%Y %H:%M:%S" ) ) 

# next, gather the sub metering columns 
df <- gather( df, location, metering, Sub_metering_1:Sub_metering_3 ) %>%
      mutate(location = as.factor( gsub("Sub_metering_", "", location ) ) )

#-------------------------------------------------------------------------

# create a 2x2 grid for the 4 plots
par( mfcol = c( 2, 2 ) )

# Upper Left Plot
ylabel <- "Global Active Power (kilowatts)"

with( power_df, plot( time_series, Global_active_power, 
                      ylab = ylabel, xlab = "", type = "l" ) )

# Lower Left Plot
ylabel <- "energy sub metering"

with( df, plot( time_series, metering, 
                ylab = ylabel, xlab = "", type = "n" ) )

points( df$time_series[ df$location == "1" ], 
        df$metering[ df$location == "1" ], type = "l" )
points( df$time_series[ df$location == "2" ], 
        df$metering[ df$location == "2" ], col = "red", type = "l" )
points( df$time_series[ df$location == "3" ], 
        df$metering[ df$location == "3" ], col = "blue", type = "l" )

legend( "topright", legend = c("Sub_metering_1 ", "Sub_metering_2 ", "Sub_metering_3 "),
         lty, lwd = "1", col = c("black", "red", "blue" ) )

# Upper Right Plot 
# NOTE: in order not to plot Voltage and Global_reactive_power 3 times,
# only one location is selected (these data are just repeated for each location)
xlabel <- "datetime"
ylabel <- "Voltage"
with( df, plot( time_series[ location == "1" ], Voltage[ location == "1" ], 
      xlab = xlabel, ylab = ylabel, type = "l" ) )

# Lower Right Plot
ylabel <- "Global_reactive_power"
with( df, plot( time_series[ location == "1" ], Global_reactive_power[ location == "1" ],
      xlab = xlabel, ylab = ylabel, type = "l" ) )

dev.copy( png, file = "plot4.png")
dev.off()

