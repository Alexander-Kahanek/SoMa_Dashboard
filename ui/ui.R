source('ui/ui.header.R')
source('ui/ui.sidebar.R')
source('ui/ui.body.R')

##########
# merge ui


onStart <- function(input, output) {
  
  ### function to detect mobile ####
  mobileDetect <- function(inputId, value = 0) {
    tagList(
      singleton(tags$head(tags$script(src = "js/mobile.js"))),
      tags$input(id = inputId,
                 class = "mobile-element",
                 type = "hidden")
    )
  }
  
}

# ui <- shinyUI({dashboardPage(header, sidebar, body)})

ui <- tagList(
  # limits page to maximun and mininum size
  tags$style("html,body{background-color: #DBDBDB;}
                .container{
                    width: 100%;
                    margin: 0 auto;
                    padding: 0;
                }
               @media screen and (min-width: 800px) and (max-width: 1200px){
                .container{
                    width: 1000px;
                }
               }"),
  tags$div(class="container",
           dashboardPage(
             header,
             sidebar,
             body
           )
  )
)