#----------------------------------------
# This script sets out to visualise
# trends data with density plots
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 29 August 2020
#----------------------------------------

#---------------------- COLLECT TRENDS DATA ------------------------

the_trends <- as.data.frame(gtrends(c("depression", "psychologist", "anxiety", "mental health", "therapist"), 
                                    geo = c("AU"), gprop = "web", time = "all", onlyInterest = TRUE)) %>%
  clean_names()

#---------------------- PRE PROCESSING -----------------------------

# Create indicator for holiday or not

trends_clean <- the_trends %>%
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
  filter(year != 2020) %>%
  mutate(holiday = case_when(
         month == "Nov" | month == "Dec" ~ "Nov-Dec",
         TRUE                            ~ "Rest of the year"))

#---------------------- DATA VISUALISATION -------------------------

the_palette <- c("#75E6DA", "#FD62AD")

p <- trends_clean %>%
  ggplot(aes(x = interest_over_time_hits)) +
  geom_density(aes(fill = holiday), alpha = 0.4) +
  labs(title = "Distribution of interest scores by time of year",
       subtitle = paste0("Data collected ", format(Sys.Date(), "%d %B %Y"), ". Data is at the monthly level."),
       x = "Interest Score",
       y = "Density",
       fill = "Time of Year") +
  theme_bw() +
  scale_fill_manual(values = the_palette) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank(),
        strip.background = element_rect(fill = "#05445E"),
        strip.text = element_text(colour = "white", face = "bold")) +
  facet_wrap(~interest_over_time_keyword)
print(p)

#---------------------- EXPORTS ------------------------------------

CairoPNG("output/density.png", 800, 600)
print(p)
dev.off()
