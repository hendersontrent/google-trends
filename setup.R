#----------------------------------------
# This script sets out to define packages
# and things used for the projects
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 27 August 2020
#----------------------------------------

# Load packages

library(tidyverse)
library(gtrendsR)
library(janitor)
library(rstan)
library(Cairo)
library(data.table)
library(viridis)
library(tidyquant)
library(forecast)

# Turn off scientific notation

options(scipen = 999)

# Create an output folder if none exists:

if(!dir.exists('output')) dir.create('output')
