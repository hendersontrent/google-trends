#----------------------------------------
# This script sets out to visualise
# trends data
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 27 August 2020
#----------------------------------------

#---------------------- COLLECT TRENDS DATA ------------------------

the_trends <- as.data.frame(gtrends(c("depression", "psychologist", "anxiety", "mental health"), 
                                    geo = c("AU"), gprop = "web", time = "all", onlyInterest = TRUE)) %>%
  clean_names()

#---------------------- DATA VISUALISATION -------------------------

# Define vector of colours for plot

the_palette <- c("#75E6DA", "#FD62AD", "#05445E", "#FEB06A")

# Make plot

p <- the_trends %>%
  ggplot(aes(x = interest_over_time_date, y = interest_over_time_hits)) +
  geom_line(aes(colour = interest_over_time_keyword)) +
  labs(title = "Time series of interest scores for mental health search terms in Australia",
       subtitle = paste0("Data collected ", format(Sys.Date(), "%d %B %Y"), ". Data is at the monthly level."),
       x = "Date",
       y = "Interest Score",
       colour = "Search Term",
       caption = "Source: Google Trends, Analysis: Orbisant Analytics") +
  theme_bw() +
  scale_colour_manual(values = the_palette) +
  theme(legend.position = "bottom")
print(p)

#---------------------- EXPORTS ------------------------------------

CairoPNG("output/time-series.png", 800, 600)
print(p)
dev.off()
