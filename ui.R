
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/


library(shiny)
library(ggvis)
shinyUI(fluidPage(#theme = "bootstrap.min.css",

  fluidRow(
    column(8,
           includeMarkdown("www/intro.Rmd")
    ),
    column(4, 
           
           "Enter your email address to indicate that you have read and agree to the terms and conditions of this scoring tool",
           textInput("email", ""),
           div(id="error"),
           br(),
           hr(),
           fileInput("file", "Select input file"),
           actionButton("submit", "Submit"),
           tags$div(style="float:right;", 
                    conditionalPanel(condition="input.submit > 0 && $('html').hasClass('shiny-busy')",
                                     h5("Processing data. Please wait."))
           ),
           uiOutput("outcome"),
           includeHTML("www/algae.js")
    )),
  fluidRow(column(12,
                  br(),
                  hr(),
                  includeMarkdown("www/disclaimer.Rmd")
  ))
))
