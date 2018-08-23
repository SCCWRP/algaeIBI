
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(algaeMetrics)
library(RSQLite)
library(reshape2)

# Connect to DB on server boot
con <- dbConnect(SQLite(), "emailDB")

shinyServer(function(input, output) {
  getData <- reactive({
    input$submit # no action until submit button is pressed
    isolate({
      if(is.null(input$file) | input$email == "") return(NULL)
      
      # Enter email into DB
      if(!input$email %in% dbReadTable(con, "email")$address)
        dbWriteTable(con, "email", data.frame(address = input$email), append=TRUE)
      
      # Read user data
      read.csv(input$file$datapath, stringsAsFactors=FALSE)
    })
  })
  
  results <- reactive(if(!is.null(getData()))try(algae.IBIs(getData())) else NULL)
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('Results-', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      write.csv(results(), con, row.names=FALSE)
    }
  )
  
  output$outcome <- renderUI({
    if(input$submit == 0 || is.null(getData()))
      return(HTML(NULL)) 
    if(class(results()) == "try-error") # print errors to UI
      results()
    else
      downloadButton("downloadData", "Download Results")
  })
})


