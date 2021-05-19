

library(shiny)

# Define UI for application 
ui <- fluidPage(

    fluidRow( # our first row
      column(6, # first argument of column function is the width of the column
             h3("My first column - row 1") # this is just an example of what can appear in this column, it can be a plot or any element.
             
             ),
      column(6,
             h3("My second column - row 1")
        
      )
    ),
    fluidRow( # our second row
      column(6,
             h3("My first column - row 2")
        
      ),
      
      column(6,
             h3("My second column - row 2")
        
      )
    )
  
)

# Define server logic , there's nothing here for now
server <- function(input, output) {

   
    
}

# Run the application 
shinyApp(ui = ui, server = server)
