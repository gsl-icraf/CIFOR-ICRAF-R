

library(shiny)

# Define UI for application 
ui <- fluidPage( # The fluidPage function ensures the layout defined within will adjust to the user's browser window
    
    # Sidebar 
    sidebarLayout(
        sidebarPanel(
            h3("Side panel")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          h3("Main panel")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

   
}

# Run the application 
shinyApp(ui = ui, server = server)
