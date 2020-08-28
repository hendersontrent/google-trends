#----------------------------------------
# This script sets out to analyse ACF
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

#---------------------- AUTOCORRELATION ----------------------------

# Depression

depression <- the_trends %>%
  filter(interest_over_time_keyword == "depression")

ggAcf(depression$interest_over_time_hits)

# Psychologist

psychologist <- the_trends %>%
  filter(interest_over_time_keyword == "psychologist")

ggAcf(psychologist$interest_over_time_hits)

# Anxiety

anxiety <- the_trends %>%
  filter(interest_over_time_keyword == "anxiety")

ggAcf(anxiety$interest_over_time_hits)

# Mental health

mental_health <- the_trends %>%
  filter(interest_over_time_keyword == "mental health")

ggAcf(mental_health$interest_over_time_hits)

# Therapist

therapist <- the_trends %>%
  filter(interest_over_time_keyword == "therapist")

ggAcf(therapist$interest_over_time_hits)
