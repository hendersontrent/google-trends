#----------------------------------------
# This script sets out to visualise
# trends data
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 28 August 2020
#----------------------------------------

#---------------------- COLLECT TRENDS DATA ------------------------

the_trends <- as.data.frame(gtrends(c("depression", "psychologist", "anxiety", "mental health", "therapist"), 
                                    geo = c("AU"), gprop = "web", time = "all", onlyInterest = TRUE)) %>%
  clean_names()

#---------------------- MODELLING ----------------------------------

the_palette <- c("#75E6DA", "#FD62AD", "#05445E", "#FEB06A", "#E7625F")

p <- the_trends %>%
  ggplot(aes(x = interest_over_time_date, y = interest_over_time_hits)) +
  geom_point(aes(colour = interest_over_time_keyword), alpha = 0.5) +
  geom_ma(ma_fun = SMA, n = 12, colour = "black", linetype = 5, size = 1.25) +
  labs(title = "Time series of interest scores for mental health search terms in Australia",
       subtitle = paste0("Data collected ", format(Sys.Date(), "%d %B %Y"), ". Line is 12-month moving average."),
       x = "Date",
       y = "Interest Score",
       colour = "Search Term",
       caption = "Source: Google Trends, Analysis: Orbisant Analytics") +
  theme_bw() +
  scale_colour_manual(values = the_palette) +
  theme(legend.position = "bottom",
        strip.background = element_rect(fill = "#05445E"),
        strip.text = element_text(colour = "white", face = "bold")) +
  facet_wrap(~interest_over_time_keyword)
print(p)

#---------------------- EXPORTS ------------------------------------

CairoPNG("output/ma-plot.png", 800, 600)
print(p)
dev.off()
