library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)
library(DT)

# read in tidy data with factors
ucr_crime <- read_csv("cleaned_data.csv") %>% 
  mutate(city = as.factor(city),
         type = as.factor(type))

ui <- navbarPage(
  # theme and title
  theme = shinytheme("yeti"),
  title = "US Violent Crime Visualization App",
 
   # First Tab for Plots
  tabPanel("Plot",
      sidebarPanel(
        # Input: Cities
        selectizeInput("cities","Choose up to 6 cities to compare:",
                    choices = ucr_crime$city,
                    multiple = TRUE,
                    selected = c("Memphis, Tenn.", "Chicago"),
                    options = list(maxItems = 6)),
        # Input: Crime type
        radioButtons("crime_type", "Crime Type:",
                     choices = c(Rape = 'Rape',
                                 Homicide = 'Homicide',
                                 Robbery = 'Robbery',
                                 `Aggravated Assault` = 'Aggravated Assault',
                                 `Total Violent Crime` = 'Total Violent Crime'),
                     selected = 'Total Violent Crime'),
        # Input: Years for line chart
        sliderInput("year_line", "Select a range of years to view:",
                    min = 1975, max = 2015, value = c(1975,2015), sep = ""),
        
        hr(),
        # Input: year for bar chart
        uiOutput('years_interval')
      ),
      # plots
      mainPanel(
        plotlyOutput("crime_ts"), 
        plotlyOutput("crime_bar")
      )
    ),
    
  # Second Panel for Data Table
    tabPanel("Data", 
             mainPanel(
               dataTableOutput("ucr_crime_filtered")
              )
    )
)

# Define server logic required to draw a histogram and a time series
server <- function(input, output) {
  
  # Reactive expression to create data frame of all input values ----

  # --------------------------------------------------------------------
  #                            Data frame for Bar Chart
  # --------------------------------------------------------------------
  crime_bar_df <- reactive({
    # Error message for empty input
    validate(
      need(input$cities != "", "Please select at least one city")
    )
    # Data frame
    ucr_crime %>% 
      filter(city %in% input$cities, 
             year == input$year_bar) %>% 
      select(year, type, n, city) %>% 
      mutate(city = fct_reorder2(city, type, n))
    })
  
  # --------------------------------------------------------------------
  #                            Data frame for line Chart
  # --------------------------------------------------------------------
  crime_ts_df <- reactive({
    # Error message for empty input
    validate(
      need(input$cities != "", "Please select at least one city")
    )
    # Data frame
    ucr_crime %>% 
      filter(city %in% input$cities,
            year <= input$year_line[2] & year >= input$year_line[1],
            type == as.name(input$crime_type)) %>% 
      select(year, n, city) %>% 
      mutate(city = fct_reorder2(city, year, n))
    })
  
  # --------------------------------------------------------------------
  #                            Dataset Table
  # --------------------------------------------------------------------
  
  ucr_crime_df <- reactive({
    # Error message for empty input
    validate(
      need(input$cities != "", "Please select at least one city")
    )
    # Data frame
    ucr_crime %>% 
      filter(city %in% input$cities,
             year <= input$year_line[2] & year >= input$year_line[1],
             type == input$crime_type) %>%
      select(city, year, type, n) 
      })
  
  # Generate all outputs -----
    
  #Bar Chart
    output$crime_bar <- renderPlotly(
      if(input$crime_type != "Total Violent Crime") {
        ggplot() +
          geom_bar(data = crime_bar_df() %>% filter(type == "Total Violent Crime"),
                   mapping = aes(y = n, x = city, fill = type),
                   stat = "identity",
                   alpha = 0.8) +
          geom_bar(data = crime_bar_df() %>% filter(type == input$crime_type),
                   mapping = aes(x = city, y = n, fill = type),
                   stat = "identity",
                   alpha = 0.8) +
          labs(fill = "") +
          xlab("") +
          ylab("Crime Rate per 100,000") +
          ggtitle(paste(input$crime_type, "vs. Total Violent Crime,", input$year_bar)) +
          coord_flip() +
          theme_bw() +
          scale_fill_viridis_d()
      } else {
        crime_bar_df() %>%
          filter(type != "Total Violent Crime") %>% 
          ggplot(aes(x = city, y = n, fill = type)) +
            geom_bar(stat = "identity") +
            xlab("") +
            ylab("Crime Rate per 100,000") +
            labs(fill = "") +
            ggtitle(paste("Composition of Total Violent Crime,", input$year_bar)) +
            coord_flip() +
            theme_bw() +
            scale_fill_viridis_d()
      }
      )
    
    #Line Chart
    output$crime_ts <- renderPlotly(
      crime_ts_df() %>% 
        ggplot(aes(x = year, y = n, colour = city)) +
          geom_line() +
          geom_point(alpha = 0.5) +
          labs(colour = "") +
          ylab(paste(input$crime_type , "per 100,000")) +
          xlab("Year") +
          ggtitle(paste(input$crime_type, "Rates", input$year_line[1], "-", input$year_line[2])) +
          theme_bw() +
          scale_colour_viridis_d(option = "C")
    )
      
    
    #Dataset
    output$ucr_crime_filtered <- DT::renderDataTable({
      DT::datatable(ucr_crime_df(), options = list(lengthMenu = c(30, 50, 100), pageLength = 10))
      })
    
    
    #Other components
    output$years_interval <- renderUI(
      selectInput("year_bar", "Select one year for the bar plot:",
                  choices = unique(c(ucr_crime$year[which(ucr_crime$year <= input$year_line[2] & ucr_crime$year >= input$year_line[1])])),
                  selected = 1))
  }
  
# Run the application 
shinyApp(ui = ui, server = server)