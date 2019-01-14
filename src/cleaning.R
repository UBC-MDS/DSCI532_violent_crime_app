library(tidyverse)

data <- read_csv("data/ucr_crime_1975_2015.csv")

data <- data %>% 
  select(city = department_name,
         total_violent_crime = violent_per_100k,
         rape = rape_per_100k,
         homicide = homs_per_100k,
         robbery = rob_per_100k,
         aggravated_assault = agg_ass_per_100k,
         year)

write_csv(data, "data/cleaned_data.csv")
  