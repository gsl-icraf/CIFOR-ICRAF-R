
library(shiny)
library(ggplot2)
library(dplyr)
library(scales)


# import data files

## confirmed cases
monthly.cases.data <- read.csv("data/monthly.cases.data.csv")

## deaths data
monthly.deaths.data <- read.csv("data/monthly.deaths.data.csv")



ui <- fluidPage(

  titlePanel("Covid19 cases in Kenya"),
  
  sidebarLayout( 
    
   sidebarPanel(
    
    h2("Widget controls"),
    br(),
    br(),
    
    # selectinput widget control for year
    selectInput("year","Select year",choices = c("2020","2021")),
    
   
    # sliderinput widget control for selecting a range of total monthly confirmed cases,
    sliderInput("cases","Select confirmed cases range", min = 0, max = max(monthly.cases.data$Monthly.Confirmed), value = c(1000,10000)),
    
    
   
   br(),
   br(),
   
   # sliderinput widget control for selecting a range of total monthly deaths,
   sliderInput("deathcases","Select death cases range", min = 0,step = 50, max = max(monthly.deaths.data$Monthly.Deaths), value = c(4,54))
   
   
    ),
  
  
  
    mainPanel( 
       fluidRow( 
     
        column(6,
           
            plotOutput("monthly.cases.plot")
            
        ),
        column(6,
          
           plotOutput("monthly.deaths.plot")
        )
     )
  )
)
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  # total confirmed cases monthly
  
  output$monthly.cases.plot <- renderPlot({
    
    # sort the months chronologically 
    monthly.cases.data$month <- factor(monthly.cases.data$month, levels = month.name)
    
    monthly.cases.data %>%
      dplyr::filter(year==input$year  & Monthly.Confirmed >=input$cases[1] & Monthly.Confirmed <= input$cases[2]) %>%
      ggplot(aes(x=month,y=Monthly.Confirmed)) +
      geom_line(group=1,color="green",size=3) +
      labs(title = "Monthly confirmed cases") +
      theme(plot.title = element_text(hjust = 0.5)) +
      scale_y_continuous(breaks = pretty_breaks(n=5))
    
  })
  
  # total deaths monthly 
  
  output$monthly.deaths.plot <- renderPlot({
    
    # sort the months chronologically
    
    monthly.deaths.data$month <- factor(monthly.deaths.data$month, levels = month.name)
    
    monthly.deaths.data %>%
      dplyr::filter(year==input$year  & Monthly.Deaths >=input$deathcases[1] & Monthly.Deaths <= input$deathcases[2]) %>%
      ggplot(aes(x=month,y=Monthly.Deaths)) +
      geom_point() +
      geom_line(group=1, color="blue",size=3) +
      labs(title = "Monthly deaths") +
      theme(plot.title = element_text(hjust = 0.5)) +
      scale_y_continuous(breaks = pretty_breaks(n=5))
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
