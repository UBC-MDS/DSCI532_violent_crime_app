library(shiny)
library(plotly)
library(tidyverse)
library(DT)

# read in tidy data with factors
ucr_crime <- read_csv("../data/cleaned_data.csv") %>% 
  mutate(city = as.factor(city),
         type = as.factor(type))

ui <- fluidPage(
  
  # Panels
  
  # App title
  titlePanel("US Violent Crime Visualization App", 
             windowTitle = "Year Range"),
  
  # Sidebar layout with input and output definitions ---- position on right
  sidebarLayout(position = "right",
    
    # Sidebar to demonstrate various slider options ----            
    sidebarPanel(
      conditionalPanel(
        'input.panel === "Plot"',
      # Input: Year Range
      sliderInput("year_line", "Select a range of years to view:",
                  min = 1975, max = 2015, value = c(1975,2015), sep = ""),
      
      # Input: Year Selected ---- Bar Chart
      
      sliderInput("year_bar", "Select one year for the bar plot:",
                  min = 1975, max = 2015,
                  value = 1985, sep = ""),
      hr(),
      
      # Input: Selected Cities -----
      selectInput("cities","Choose some cities to compare:",
                  choices = ucr_crime$city,
                  multiple = TRUE,
                  selected = c("Memphis, Tenn.", "Chicago")),
      
      # Input: Select Crime type ----
      radioButtons("crime_type", "Crime Type:",
                   choices = c(Rape = 'Rape',
                               Homicide = 'Homicide',
                               Robbery = 'Robbery',
                               `Aggravated Assault` = 'Aggravated Assault',
                               `Total Violent Crime` = 'Total Violent Crime'),
                   selected = 'Total Violent Crime')
      )
    ),

    # Main panel for displaying outputs -----
    mainPanel(
      tabsetPanel(
        id = 'panel',
        tabPanel("Plot", fluidRow(plotlyOutput("crime_ts"), 
                                  plotlyOutput("crime_bar"))),
        tabPanel('Data', dataTableOutput("ucr_crime_filtered"))
      )
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
          labs(fill = "Type") +
          xlab("Year") +
          ylab("Crime Rate per 100,000") +
          ggtitle(paste(input$crime_type, "vs. Total Violent Crime,", input$year_bar)) +
          theme_bw() +
          scale_fill_viridis_d()
      } else {
        crime_bar_df() %>%
          filter(type != "Total Violent Crime") %>% 
          ggplot(aes(x = city, y = n, fill = type)) +
            geom_bar(stat = "identity") +
            xlab("Year") +
            ylab("Crime Rate per 100,000") +
            ggtitle(paste("Composition of Total Violent Crime,", input$year_bar)) +
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
          labs(colour = "Cities") +
          ylab(paste(input$crime_type , "per 100,000")) +
          xlab("Year") +
          ggtitle(paste(input$crime_type, "Rates", input$year_line[1], "-", input$year_line[2])) +
          theme_bw() +
          scale_colour_viridis_d()
    )
      
    
    #Dataset
    output$ucr_crime_filtered <- DT::renderDataTable({
      DT::datatable(ucr_crime_df(), options = list(lengthMenu = c(30, 50, 100), pageLength = 10))
      })
  }
  
# Run the application 
shinyApp(ui = ui, server = server)