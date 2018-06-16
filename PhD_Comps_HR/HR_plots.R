# Load required packages
library(ggplot2)
library(ggthemes)
library(smooth)
library(zoo)
library(fpp2)

# Read in data 
Comps_HR <- read.csv("Comps_HR_clean.csv", header = TRUE)
Comps_HR$Timestamp <- Comps_HR$Timestamp / 60

# Compute rolling means to smooth out the curve
hr_ma10 <- rollmean(Comps_HR$Heartrate, k = 150)

plot(hr_ma10)

# HR limits for color scale
hr_max <- ceiling(max(Comps_HR$Heartrate))
hr_min <- floor(min(Comps_HR$Heartrate))

time_max <- ceiling(max(Comps_HR$Timestamp))
time_mix <- floor(min(Comps_HR$Timestamp))

# Plot the graph
Comps_HR_plot <- ggplot(Comps_HR, aes(x = Timestamp, y = Heartrate, group = 1, color = Heartrate)) + geom_line() + geom_point(size = 0.7, shape = 3) + theme_tufte() + theme(axis.title = element_text(size = 14), axis.line = element_line(), legend.position = "none") + scale_y_continuous(limits = c(hr_min, hr_max), breaks=seq(50, 150, 10)) + scale_x_continuous(limits = c(time_min, time_max), breaks=seq(0, 150, 15)) + scale_color_gradient(low = "#66FF00", high = "red", breaks=seq(hr_min, hr_max, 20), limits=c(hr_min, hr_max)) + geom_hline(aes(yintercept = 84), linetype = "dashed", color = "black") + xlab("Time (mins)") + ylab("Heart Rate (bpm)")

# Write plot to a file
ggsave(file = paste("~/Desktop/Comps_HR", ".png"), plot = Comps_HR_plot, width = 11.43, height = 7.29)
