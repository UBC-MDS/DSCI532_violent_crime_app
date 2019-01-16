library(tidyverse)

data <- read_csv("data/cleaned_data.csv") %>% 
  mutate(city = as.factor(city),
         type = as.factor(type))


ts_plot <- data %>%
  filter(city %in% c( "Boston",  "Memphis, Tenn.", "Newark, N.J."),
         type == "Total Violent Crime") %>%
  ggplot(aes(y = n, x = year, colour = fct_reorder2(city, year, n))) +
  geom_point(alpha = 0) +
  geom_smooth() +
  geom_line(alpha = 0.5) +
  labs(colour = "City") +
  ylab("Total Violent Crime Rate per 100,000") +
  theme_bw()

ts_plot


# 
# p1 <-  data %>%
#   filter(city %in% c("Atlanta", "Boston", "Chicago"),
#          year == 2000,
#          type == "Total Violent Crime")%>%
#   ggplot() +
#     geom_bar(mapping = aes(x = city, y = n), stat = "identity", fill = red) +
#     geom_bar(mapping = aes(x = city, y = n), stat = "identity",
#              data = data %>% 
#                filter(city %in% c("Atlanta", "Boston", "Chicago"),
#                       year == 2000,
#                       type == "Murder"))

bars <- ggplot() + 
  geom_bar(data = data %>% 
             filter(city %in% c("Atlanta", "Boston", "Chicago"),
                    year == 2000,
                    type == "Total Violent Crime"),
          mapping = aes(x = city, y = n, fill = "Total"), 
          stat = "identity",
          alpha = 0.8) +
  geom_bar(data = data %>% filter(city %in% c("Atlanta", "Boston", "Chicago"),
                                      year == 2000,
                                      type == "Robbery"),
           mapping = aes(x = city, y = n, fill = "Robbery"), 
           stat = "identity",
           alpha = 0.8) +
  labs(fill = "Type") +
  theme_bw()
  



