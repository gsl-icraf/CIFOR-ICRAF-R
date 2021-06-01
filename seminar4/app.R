#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# load required packages
library(shiny)
library(ggplot2)
library(RColorBrewer)

# change data file path to match local directory structure
data.file.path <- 'data/covid19-cases-kenya.csv'

# read data from the file
covid19.data.kenya <- read.csv(data.file.path) 
covid19.data.kenya$Date <- as.Date(covid19.data.kenya$Date, format="%y-%m-%d")

# Add Year attribute for filtering dataset by year
covid19.data.kenya$Year <- format(covid19.data.kenya$Date, "%Y")

# Define UI for the application 
ui <- fluidPage(

    # Application title
    titlePanel("Covid 19 Data Analysis, Kenya"),

    # Sidebar
    sidebarLayout(
        sidebarPanel(
            h2("Daily Confirmed Cases Reactive Inputs"),
            # confirmed cases line plot input options
            selectInput(
                'confYear',
                h3("Select Year of Concern"),
                unique(covid19.data.kenya$Year)
            ),
            selectInput(
                'confLineColor',
                h3("Select Line Color"),
                brewer.pal(11, 'Spectral')
            ),
            selectInput(
                'confDotColor',
                h3("Select Dot Color"),
                brewer.pal(8, 'Accent')
            ),
            # cummulative cases input options
            h2("Cumulative Cases Reactive Inputs"),
            selectInput(
                'cumYear',
                h3("Select Year of Concern"),
                unique(covid19.data.kenya$Year)
            ),
            selectInput(
                'cumPositiveColor',
                h3("Select Positive Cases Line Color"),
                brewer.pal(9, 'Pastel1')
            ),
            selectInput(
                'cumRcoveryColor',
                h3("Select Recovery Line Color"),
                brewer.pal(11, 'Accent')
            ),
            selectInput(
                'cumDeathColor',
                h3("Select Death Line Color"),
                brewer.pal(8, 'RdGy')
            ),
        ),
        # Main Panel
        mainPanel(
           fluidRow(
               column(12, plotOutput("confCases"))
           ),
           br(),
           hr(),
           br(),
           fluidRow(
               column(12, plotOutput("cumCases"))
           )
        )
    )
)

# Define server logic required to handle ui outputs
server <- function(input, output) {
    
    output$confCases <- renderPlot({
        
        selYear <- input$confYear
        lineColor <- input$confLineColor
        dotColor <- input$confDotColor
        
        # filter data based on seleted year
        data <- subset(covid19.data.kenya, Year == selYear)
        
        graphic <- ggplot(data, aes(x = Date, y = Daily.Confirmed)) +
            geom_line(colour=lineColor, show.legend = FALSE) +
            geom_point(colour=dotColor, show.legend = FALSE) + 
            labs(
                title = "Daily Covid 19 Confirmed Cases in Kenya",
                x = "Date",
                y = "Confirmed Positive Cases"
            ) + 
            theme(plot.title = element_text(hjust = 0.5))
        graphic
    })
    
    output$cumCases <- renderPlot({
            
        selYear <- input$cumYear
        posColor <- input$cumPositiveColor
        recColor <- input$cumRcoveryColor
        deathColor <- input$cumDeathColor
        
        colors <- c("Positive" = posColor, "Recoveries" = recColor, "Deaths" = deathColor)
        
        # filter data based on seleted year
        data <- subset(covid19.data.kenya, Year == selYear)
        
        ggplot(data, mapping = aes(x = Date)) + 
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
