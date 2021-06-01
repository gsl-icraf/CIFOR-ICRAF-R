

library(shiny)

# Define UI 
ui <- navbarPage( "Application title",
                  tabPanel("Module 1",
                           h3("Contents for Module 1")),
                  tabPanel("Module 2",
                           h3("Contents for Module 2")),
                  tabPanel("Module 3",
                           h3("Contents for Module 3"))
)

# Define server logic 
server <- function(input, output) {

    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
