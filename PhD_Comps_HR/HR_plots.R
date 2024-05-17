# Load required packages
library(ggplot2)
library(ggthemes)
library(grid)
library(smooth)
library(zoo)
library(fpp2)

# Define the width and height of the output
output_dpi <- 300
output_width <- 11.43
output_height <- 7.29

# Read in data
comps_hr <- read.csv("comps_hr_clean.csv", header = TRUE)
comps_hr$Timestamp <- comps_hr$Timestamp / 60

# Compute rolling means to smooth out the curve
hr_ma10 <- rollmean(comps_hr$Heartrate, k = 150)

# plot(hr_ma10)

# HR limits for color scale
hr_max <- ceiling(max(comps_hr$Heartrate))
hr_min <- floor(min(comps_hr$Heartrate))

time_max <- ceiling(max(comps_hr$Timestamp))
time_min <- floor(min(comps_hr$Timestamp))

# Plot the graph
comps_hr_plot <- ggplot(
    comps_hr,
    aes(
        x = Timestamp, y = Heartrate,
        group = 1, color = Heartrate
    )
) +
    geom_line() +
    geom_point(size = rel(0.7), shape = 3) +
    theme_fivethirtyeight() +
    theme(
        axis.title.x = element_text(
            size = 14,
            family = "Roboto",
            margin = margin(t = 10, r = 0, b = 0, l = 0)
        ), # Add top margin to x axis title
        axis.title.y = element_text(
            size = 14,
            family = "Roboto",
            margin = margin(t = 0, r = 10, b = 0, l = 0)
        ),
        axis.text = element_text(size = 10, family = "Roboto"),
        axis.line = element_line(), legend.position = "none"
    ) +
    scale_y_continuous(
        limits = c(hr_min, hr_max),
        breaks = seq(50, 150, 10)
    ) +
    scale_x_continuous(
        limits = c(time_min, time_max),
        breaks = seq(0, 150, 15)
    ) +
    scale_color_gradient(
        low = "#66FF00", high = "red",
        breaks = seq(hr_min, hr_max, 20), limits = c(hr_min, hr_max)
    ) +
    geom_hline(aes(yintercept = 84),
        linetype = "dashed",
        color = "black"
    ) +
    annotate("segment",
        x = 20, xend = 10,
        y = 140, yend = 140,
        arrow = arrow(length = unit(0.009, "npc"))
    ) +
    annotate("text",
        x = 21, y = 140,
        label = "Initial Nervousness",
        size = rel(4), hjust = -0.05,
        family = "Roboto"
    ) +
    annotate("segment",
        x = 48, xend = 34,
        y = 115, yend = 106,
        arrow = arrow(length = unit(0.009, "npc"))
    ) +
    annotate("segment",
        x = 55, xend = 67,
        y = 115, yend = 99,
        arrow = arrow(length = unit(0.009, "npc"))
    ) +
    annotate("text",
        x = 39, y = 116,
        label = "Challenging Questions?",
        size = rel(4), hjust = 0, vjust = -1,
        family = "Roboto"
    ) +
    annotate("segment",
        x = 128, xend = 134,
        y = 107, yend = 104,
        arrow = arrow(length = unit(0.009, "npc"))
    ) +
    annotate("text",
        x = 118, y = 108,
        label = "Awaiting Results",
        size = rel(4),
        family = "Roboto"
    ) +
    annotate("text",
        x = 0, y = 82,
        label = "Average HR: 84 bpm",
        size = rel(3), hjust = 0.2,
        family = "Roboto",
        color = "#5252fd"
    ) +
    xlab("Time (mins)") +
    ylab("Heart Rate (bpm)")

# Write plot to a file
ggsave(
    file = paste0("comps_hr", ".png"),
    plot = comps_hr_plot,
    width = output_width,
    height = output_height,
    dpi = output_dpi
)
