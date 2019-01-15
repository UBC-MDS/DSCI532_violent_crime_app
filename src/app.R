library(shiny)
library(tidyverse)
library(ggplot2)
ucr_crime <- read.csv("../data/ucr_crime_1975_2015.csv", stringsAsFactors = FALSE)

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
        'input.panel === "plot"',
      #Input: Year Range
      sliderInput("year_line", "Select your desired year range:",
                  min = 1975, max = 2015, value = c(1975,2015)),
      
      #Input: Year Selected ---- Bar Chart
      
      sliderInput("year_bar", "Select your desired year for bar:",
                  min = 1975, max = 2015,
                  value = 1985),
      hr(),
      
      #Input: Selected Cities -----
      selectInput("city1","Choose the first city:",
                  choices = ucr_crime$department_name),
      
      selectInput("city2","Choose the second city:",
                  choices = ucr_crime$department_name),
      
      selectInput("city3","Choose the third city:",
                  choices = ucr_crime$department_name),
      
      selectInput("city4","Choose the fourth city:",
                  choices = ucr_crime$department_name),
      
      #Input: Select Crime type ----
      radioButtons("crime_type", "Crime Type:",
                   choices = c(Rape = 'rape_per_100k',
                               Homicide = 'homs_per_100k',
                               Robbery = 'rob_per_100k',
                               `Aggravated Assault` = 'agg_ass_per_100k',
                               All = 'violent_per_100k'),
                   selected = "violent_per_100k")
      )
    ),
    
    # Main panel for displaying outputs -----
    mainPanel(
      tabsetPanel(
        id = 'panel',
        tabPanel("plot", fluidRow(plotOutput("crime_bar"), 
                                  plotOutput("crime_ts"))),
        tabPanel('data', DT::dataTableOutput("ucr_crime_filtered"))
      )
    )
  )
)



# Define server logic required to draw a histogram and a time series
server <- function(input, output) {
  
  # Reactive expression to create data frame of all input values ----
  
  # --------------------------------------------------------------------
  #                            Bar Chart
  # --------------------------------------------------------------------
  crime_bar_df <- reactive({
    ucr_crime %>% 
      filter(department_name %in% c(input$city1, input$city2, input$city3, input$city4)) %>%
      filter(year == input$year_bar)})
  
  # --------------------------------------------------------------------
  #                            line Chart
  # --------------------------------------------------------------------
  crime_ts_df <- reactive({
    ucr_crime %>% 
      filter(department_name %in% c(input$city1, input$city2, input$city3, input$city4)) %>%
      filter(year <= input$year_line[2] & year >= input$year_line[1])})
  
  # --------------------------------------------------------------------
  #                            Dataset Table
  # --------------------------------------------------------------------
  
  ucr_crime_df <- reactive({
    ucr_crime %>% 
      filter(department_name %in% c(input$city1, input$city2, input$city3, input$city4)) %>%
      filter(year <= input$year_line[2] & year >= input$year_line[1]) %>% 
      select('department_name', 'year', input$crime_type) %>% 
      arrange(department_name)
      })
  
  # Generate all outputs -----
    #Bar Chart
    output$crime_bar <- renderPlot(
      crime_bar_df() %>% 
        ggplot(aes(department_name,eval(as.name(input$crime_type)))) + geom_bar(stat="identity"))
    #Line Chart
    output$crime_ts <- renderPlot(
      crime_ts_df() %>% 
        ggplot(aes(year,eval(as.name(input$crime_type)), colour=department_name)) + geom_line())
    #Dataset
    output$ucr_crime_filtered <- DT::renderDataTable({
      DT::datatable(ucr_crime_df(), options = list(lengthMenu = c(30, 50, 100), pageLength = 10))})
  }
  
# Run the application 
shinyApp(ui = ui, server = server)