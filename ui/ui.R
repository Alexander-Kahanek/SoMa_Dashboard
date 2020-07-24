source('ui/parts/header.R')
source('ui/parts/sidebar.R')
source('ui/parts/body.R')

##########
# merge ui

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