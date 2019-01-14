library(tidyverse)

data <- read_csv("data/ucr_crime_1975_2015.csv")

data <- data %>% 
  select(city = department_name,
         `Total Violent Crime` = violent_per_100k,
         Rape = rape_per_100k,
         Homicide = homs_per_100k,
         Robbery = rob_per_100k,
         `Aggravated Assault` = agg_ass_per_100k,
         year) %>% 
  gather(key = "type", value = "n", 2:6 )

write_csv(data, "data/cleaned_data.csv")


  