source('global.R')
source('ui/ui.R', local = TRUE)
source('server/server.R')

#############################################################
# run application


shinyApp(
  ui = ui,
  server = server
)

# library(rsconnect)
# rsconnect::deployApp(getwd(), account="rubbishlove")