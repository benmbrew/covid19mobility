# # Pull from JHU
# system('cd ../../covid19; pwd; git pull;')
# system('cd ../../covid-19-data; pwd; git pull;')
# 
# # read in
# # load libraries
# library(tidyverse)
# library(dplyr)
# library(readr)
# library(spatstat)
# library(riem)
# library(reshape2)
# 
# ##### -------- get weather data by state
# # temp <- riem_measures(station = "SFO", date_start = "2010-01-01")
# weather <- readr::read_csv('weather.csv')
# names(weather) <- c('state', 'avg_f', 'avg_c', 'rank')
# 
# usethis::use_data(weather, overwrite = T)
# 
# ##### ------- Read in data
# # read in world and country data
# load('../../covid19/data/df.rda')
# load('../../covid19/data/df_country.rda')
# load('../../covid19/data/regions_pop.rda')
# 
# usethis::use_data(df, overwrite = T)
# usethis::use_data(df_country, overwrite = T)
# usethis::use_data(regions_pop, overwrite = T)
# 
# # get states 
# usa <- df %>% filter(country == 'US')
# state_names <- unique(usa$district)
# usethis::use_data(state_names, overwrite = T)
# 
# 
# # read in nytimes data
# excess <- readr::read_csv('../../covid-19-data/excess-deaths/deaths.csv')
# usethis::use_data(excess, overwrite = T)
# 
# # read in mobility repot
# mob <- read_csv('Global_Mobility_Report.csv')
# names(mob) <- ifelse(names(mob) == 'retail_and_recreation_percent_change_from_baseline', 'Retail',
#                      ifelse(names(mob) == 'grocery_and_pharmacy_percent_change_from_baseline', 'Grocery',
#                             ifelse(names(mob) == 'parks_percent_change_from_baseline', 'Parks',
#                                    ifelse(names(mob) == 'transit_stations_percent_change_from_baseline', 'Transit',
#                                           ifelse(names(mob) == 'workplaces_percent_change_from_baseline', 'Workplace',
#                                                  ifelse(names(mob) == 'residential_percent_change_from_baseline', 'Residential', names(mob)))))))
# # mobility data
# mob_usa <- mob %>% filter(country_region == 'United States') %>% group_by(sub_region_1, date) %>%
#   summarise(Retail = mean(Retail, na.rm = TRUE),
#             Grocery = mean(Grocery, na.rm = TRUE),
#             Parks = mean(Parks, na.rm = TRUE),
#             Workplace = mean(Workplace, na.rm = TRUE),
#             Transit = mean(Transit, na.rm = TRUE),
#             Residential = mean(Residential, na.rm = TRUE))
# rm(mob)
# usethis::use_data(mob_usa, overwrite = T)
# 
# # read in lockdown data
# lock <- readr::read_csv('states_locked.csv')
# usethis::use_data(lock, overwrite = T)
