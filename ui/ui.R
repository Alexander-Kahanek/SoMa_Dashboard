source('ui/ui.header.R')
source('ui/ui.sidebar.R')
source('ui/ui.body.R')

##########
# merge ui


# onStart <- function(input, output) {
#   
#   ### function to detect mobile ####
#   mobileDetect <- function(inputId, value = 0) {
#     tagList(
#       singleton(tags$head(tags$script(src = "js/mobile.js"))),
#       tags$input(id = inputId,
#                  class = "mobile-element",
#                  type = "hidden")
#     )
#   }
#   
# }

# no control of window size
# ui <- shinyUI({dashboardPage(header, sidebar, body)})

ui <- tagList(
  # allows for control of viewport size
  tags$div(class="container",
           dashboardPage(
             header,
             sidebar,
             body
           )
  )
)