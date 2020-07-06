source('ui.header.R')
source('ui.sidebar.R')
source('ui.body.R')

##########
# merge ui
ui <- shinyUI({dashboardPage(header, sidebar, body)})