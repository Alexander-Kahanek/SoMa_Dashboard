library(shinydashboard)
library(shinyWidgets)

################
# create sidebar
sidebar <- dashboardSidebar(
  

  # lightpink F4B2F8 # F6A2FC # rubbish E935f2
  # tags$head(tags$style(HTML('.logo {
  #                             background-color: #F6A2FC !important;
  #                             }
  #                             .navbar {
  #                             background-color: #E935f2 !important;
  #                             }
  #                             ')))
  
  # The dynamically-generated user panel
  uiOutput("userpanel")
  
  ,collapsed = FALSE
  
  # ,fluidRow( # blank space
  #   align = "center"
  #   ,column(12
  #           # ,box(width="100%", height = "5px")
  #           ,h5(HTML("<b>Global Options</b>"))
  #   )
  # )
  
  
  ####################### # #
  # change filtering of data (main objects)
  ####################### # #
  ,checkboxGroupButtons(
    inputId = "usrObjs"
    ,justified = TRUE
    ,direction = "vertical"
    ,label = HTML("<b>Filter by Objects Found</b>")
    ,choices = list(
      # add amounts to options
      # change if 'change everything mode is on'
      "Litter" = objTypes[[1]]
      ,"Grease and Gum Stains" = objTypes[[2]]
      ,"Graffiti" = objTypes[[3]]
      ,"Needles" = objTypes[[4]]
      ,"Broken Glass" = objTypes[[5]]
      ,"Poop and Urine" = objTypes[[6]]
    )
    ,selected = objTypes[-2] # no grease and gum stains on start
    ,status = btnColor
    ,checkIcon = list(
      yes = icon("ok", 
                 lib = "glyphicon"),
      no = icon("remove",
                lib = "glyphicon"))
  )
  
  ####################### # #
  # change filtering of data (issue objects)
  ####################### # #
  ,checkboxGroupButtons(
    inputId = "usrIssues"
    ,justified = TRUE
    ,direction = "vertical"
    ,label = HTML("<b>Filter by Issues Found</b>")
    ,choices = list(
      # add amounts to options
      # change if 'change everything mode is on'
      "Trash Can Issue" = issueTypes[[1]]
      ,"Tree Issue" = issueTypes[[2]]
      ,"Other Issue" = issueTypes[[3]]
    )
    ,selected = issueTypes
    ,status = btnColor
    ,checkIcon = list(
      yes = icon("ok", 
                 lib = "glyphicon"),
      no = icon("remove",
                lib = "glyphicon"))
  )
  
  
  ,fluidRow( # blank space
    align = "center"
    ,column(12
            ,box(width="100%", height = "5px")
            ,h5(HTML("<b>Options for Map</b>"))
    )
  )
  
  
  #############
  # change color of map
  #############
  
  ,radioGroupButtons(
    inputId = "usrColor"
    ,label = HTML("<b>Color By Options</b>")
    ,direction = "vertical"
    ,justified = TRUE
    ,choices = c(
      "Objects and Issues" = "ObjsIssues"
      ,"Object Type" = "Types"
      ,"Street Location" = "Streets"
      ,"Zone Classification" = "classification"
    )
    
    ,status = btnColor
    ,checkIcon = list(
      yes = icon(
        "ok"
        ,lib = "glyphicon"
      )
      # ,no = icon(
      #   "remove"
      #   ,lib = "glyphicon"
      # )
    )
    ,width = "100%"
  )
  
  
  ,fluidRow( # blank space
    align = "center"
    ,column(12
            ,box(width="100%", height = "5px")
            ,h5(HTML("<b>Options for Bin Heat Map</b>"))
    )
  )
  
  
  ,sliderTextInput(
    inputId = "usrxbins"
    ,width = "100%"
    ,selected = 10
    ,label = HTML("<b>Number of columns (Vertical)</b>")
    ,choices = c(seq(1,200, b=1))
    ,grid = FALSE
  )
  
  ,sliderTextInput(
    inputId = "usrybins"
    ,width = "100%"
    ,selected = 10
    ,label = HTML("<b>Number of rows (Horizontal)</b>")
    ,choices = c(seq(1,200, b=1))
    ,grid = FALSE
  )
  
  ,prettySwitch(
    inputId = "useScreen"
    ,label = HTML("<b>Match map boundaries</b>")
    # ,label_off = "Show all points visible on map"
    # ,icon_on = icon("bar-chart", lib = "font-awesome")
    # ,icon_off = icon("remove", lib = "glyphicon")
    ,value = TRUE
    ,status = "success"
    # ,status_off = "danger"
    # ,shape = "curve"
    # ,outline = FALSE
    # ,fill = TRUE
    # ,bigger = TRUE
    # ,animation = "pulse"
    ,width = "100%"
  )
  
  ,HTML('<script> document.title = "Rubbish Dashboard"; </script>')
  # ,actionButton(inputId = "applyChoices", label = "Click to apply!")
)
