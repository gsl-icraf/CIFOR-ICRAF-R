#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button on top-right corner of RStudio IDE code panel.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Data source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series

# change data file path to match local directory structure
data.file.path <- 'data/covid19-cases-kenya.csv'
# read data from the file
covid19.data.kenya <- read.csv(data.file.path) 
covid19.data.kenya$Date <- as.Date(covid19.data.kenya$Date, format="%y-%m-%d")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Covid 19 Confirmed Cases, Kenya"),
    # Create a row that will hold plots of positive confirmed cases 
    fluidRow(
        column(width = 6, plotOutput("positiveCases")),
        column(width = 6, plotOutput("positiveCasesDist"))
    ),
    # Create row to hold comparison graphics
    fluidRow(
        column(width = 6, plotOutput("compareDaily")),
        column(width = 6, plotOutput("compareTotal"))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$positiveCases <- renderPlot({
        ggplot(data = covid19.data.kenya, mapping = aes(x = Date, y = Daily.Confirmed)) + 
            geom_line(colour="blue", show.legend = FALSE) +
            geom_point(colour="cyan", show.legend = FALSE) + 
            labs(
                title = "Daily Covid 19 Confirmed Cases in Kenya",
                x = "Date",
                y = "Confirmed Positive Cases"
            ) + 
            theme(plot.title = element_text(hjust = 0.5))
    })
    
    output$positiveCasesDist <- renderPlot({
        ggplot(covid19.data.kenya, aes(x = "Kenya", y = Daily.Confirmed)) +  
            geom_boxplot(colour="cyan", show.legend = FALSE, outlier.color = "red") +
            stat_summary(fun=mean, geom="point", shape=20, size=3, color="brown") +
            labs(
                title = "Distribution of Covid 19 Confirmed Cases",
                x = "",
                y = "Confirmed Cases"
            ) + 
            theme(plot.title = element_text(hjust = 0.5))
    })
    
    output$compareDaily <- renderPlot({
        # remove strange entries with over 3,000 recoveries in a day
        cleaned.data <- subset(covid19.data.kenya, Daily.Recoveries < 3000)
        colors <- c("Positive" = "cyan", "Recoveries" = "green", "Deaths" = "red")
        ggplot(cleaned.data, mapping = aes(x = Date)) + 
            geom_line(aes(y = Daily.Confirmed, color = "Positive")) + 
            geom_line(aes(y = Daily.Recoveries, color = "Recoveries")) + 
            geom_line(aes(y = Daily.Deaths, color = "Deaths")) +
            labs(
                title = "A Comparison of Daily Confirmed Cases in Kenya",
                x = "Date",
                y = "Cases Count",
                color = "Confirmed Cases"
            ) + 
            scale_color_manual(values = colors) +
            theme(
                plot.title = element_text(hjust = 0.5),
                legend.position = c(.05, .95),
                legend.justification = c("left", "top")
            )
    })
    
    output$compareTotal <- renderPlot({
        colors <- c("Positive" = "cyan", "Recoveries" = "green", "Deaths" = "red")
        ggplot(covid19.data.kenya, mapping = aes(x = Date)) + 
            geom_line(aes(y = Total.Confirmed, color = "Positive")) + 
            geom_line(aes(y = Total.Recoveries, color = "Recoveries")) + 
            geom_line(aes(y = Total.Deaths, color = "Deaths")) +
            labs(
                title = "A Comparison of Cumulative Confirmed Cases in Kenya",
                x = "Date",
                y = "Cumulative Cases",
                color = 'Confirmed Cases'
            ) + 
            scale_color_manual(values = colors) +
            theme(
                plot.title = element_text(hjust = 0.5),
                legend.position = c(.05, .95),
                legend.justification = c("left", "top")
            )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
