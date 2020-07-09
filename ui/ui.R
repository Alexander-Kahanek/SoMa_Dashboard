source('ui/ui.header.R')
source('ui/ui.sidebar.R')
source('ui/ui.body.R')

##########
# merge ui
ui <- shinyUI({dashboardPage(header, sidebar, body)})