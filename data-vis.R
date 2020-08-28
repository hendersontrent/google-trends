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

the_trends <- as.data.frame(gtrends(c("depression", "psychologist", "anxiety", "mental health", "therapist"), 
                                    geo = c("AU"), gprop = "web", time = "all", onlyInterest = TRUE)) %>%
  clean_names()

#---------------------- DATA VISUALISATION -------------------------

# Time series plot

the_palette <- c("#75E6DA", "#FD62AD", "#05445E", "#FEB06A", "#E7625F")

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

# Seasonality plot

p1 <- the_trends %>%
  mutate(month = gsub(".*[-]([^.]+)[-].*", "\\1", interest_over_time_date)) %>%
  mutate(month = case_when(
         month == "01" ~ "Jan",
         month == "02" ~ "Feb",
         month == "03" ~ "Mar",
         month == "04" ~ "Apr",
         month == "05" ~ "May",
         month == "06" ~ "Jun",
         month == "07" ~ "Jul",
         month == "08" ~ "Aug",
         month == "09" ~ "Sep",
         month == "10" ~ "Oct",
         month == "11" ~ "Nov",
         month == "12" ~ "Dec")) %>%
  mutate(year = gsub("-.*", "", interest_over_time_date)) %>%
  mutate(year = as.numeric(year)) %>%
  mutate(month = factor(month, levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))) %>%
  mutate(latestyear = (year == max(year))) %>%
  ggplot(aes(x = month, y = interest_over_time_hits, group = as.factor(year), 
             colour = year, alpha = latestyear)) +
  geom_line(size = 0.75) +
  labs(title = "Seasonality of interest scores for mental health search terms in Australia",
       subtitle = paste0("Data collected ", format(Sys.Date(), "%d %B %Y"), ". Data is at the monthly level."),
       x = "Month",
       y = "Interest Score",
       colour = NULL,
       fill = NULL,
       caption = "Source: Google Trends, Analysis: Orbisant Analytics") +
  scale_alpha_discrete(range = c(0.25, 1), guide = "none") +
  scale_color_viridis("", direction = -1, guide = guide_legend(reverse = FALSE))  +
  guides(fill = NULL) +
  theme_bw() +
  theme(legend.position = "bottom",
        strip.background = element_rect(fill = "#05445E"),
        strip.text = element_text(colour = "white", face = "bold")) +
  facet_wrap(~interest_over_time_keyword)
print(p1)

#---------------------- EXPORTS ------------------------------------

CairoPNG("output/time-series.png", 800, 600)
print(p)
dev.off()

CairoPNG("output/seasonality.png", 800, 600)
print(p1)
dev.off()
