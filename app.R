library(shiny)
library(shinyWidgets)
library(shinydashboard)
source('global.R')
source('ui.R', local = TRUE)
source('server.R')

#############################################################
# run application

shinyApp(
  ui = ui,
  server = server
)