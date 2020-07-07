source('global.R')
source('ui.R', local = TRUE)
source('server.R')

#############################################################
# run application

# ggplot swap axis, scale_x_continuous()
# position = "left",

shinyApp(
  ui = ui,
  server = server
)

# library(rsconnect)
# deployApp(getwd())