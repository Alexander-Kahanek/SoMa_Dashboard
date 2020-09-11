source('ui/parts/header.R')
source('ui/parts/sidebar.R')
source('ui/parts/body.R')

##########
# merge ui

# no control of window size
# ui <- shinyUI({dashboardPage(header, sidebar, body)})

ui <- tagList(
  
  tags$style(
    # limits page to maximun and mininum size  
    includeHTML("backend/html/min&max_viewport.html")
    )
  
  # allows for control of viewport size
  ,tags$div(class="container",
           dashboardPage(
             header,
             sidebar,
             body
           )
  )
)