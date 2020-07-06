################
# create sidebar
sidebar <- dashboardSidebar(
  
  # Custom CSS to hide the default logout panel
  # lightpink F4B2F8 # F6A2FC # rubbish E935f2
  tags$head(tags$style(HTML('.logo {
                              background-color: #F6A2FC !important;
                              }
                              .navbar {
                              background-color: #E935f2 !important;
                              }
                              ')))
  
  # The dynamically-generated user panel
  ,uiOutput("userpanel")
  
  # stat box toggle switch
  ########################## # #
  # change color on checkbox
  ########################## # #
  ,prettyToggle(
    inputId = "TFstat"
    ,label_on = "Showing Stat Box"
    ,label_off = "Hiding Stat Box"
    ,icon_on = icon("bar-chart", lib = "font-awesome")
    ,icon_off = icon("remove", lib = "glyphicon")
    ,value = TRUE
    ,status_on = "success"
    ,status_off = "danger"
    ,shape = "curve"
    ,outline = FALSE
    ,fill = TRUE
    ,bigger = TRUE
    ,animation = "pulse"
    ,width = "100%"
  )
  
  # checkboxes for object types
  ####################### # #
  # change color on boxes
  ####################### # #
  ,checkboxGroupButtons(
    inputId = "usrObjs"
    ,justified = TRUE
    ,direction = "vertical"
    ,label = "Filter by Object Types"
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
    ,selected = objTypes
    ,status = "primary"
    ,checkIcon = list(
      yes = icon("ok", 
                 lib = "glyphicon"),
      no = icon("remove",
                lib = "glyphicon"))
  )
  
  # checkboxes for other types
  ####################### # #
  # change color on boxes
  ####################### # #
  ,checkboxGroupButtons(
    inputId = "usrIssues"
    ,justified = TRUE
    ,direction = "vertical"
    ,label = "Filter by Other Types"
    ,choices = list(
      # add amounts to options
      # change if 'change everything mode is on'
      "Trash Can Issue" = issueTypes[[1]]
      ,"Tree Issue" = issueTypes[[2]]
      ,"Other Issue" = issueTypes[[3]]
    )
    ,selected = issueTypes
    ,status = "danger"
    ,checkIcon = list(
      yes = icon("ok", 
                 lib = "glyphicon"),
      no = icon("remove",
                lib = "glyphicon"))
  )
  
  ############
  # add options: color changes
  # area type choices?
  # other classifiers?
  
  ,radioGroupButtons(
    inputId = "usrColor"
    ,label = "Map Color Choices"
    ,direction = "vertical"
    ,choices = c(
      "Objects and Issues" = "ObjsIssues"
      ,"Color by Type" = "Types"
      ,"Color by Street" = "Streets"
    )
                
    ,status = "primary"
    ,checkIcon = list(
      yes = icon(
        "ok"
        ,lib = "glyphicon"
        )
      ,no = icon(
        "remove"
        ,lib = "glyphicon"
      )
    )
  )
  
  ############
  # add options: map options
  # overlay?
  # icons?
)