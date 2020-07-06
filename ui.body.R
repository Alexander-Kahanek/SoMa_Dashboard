#############
# create body
body <- dashboardBody(
  
  # JS for Text after logo and sidebar button
  tags$head(tags$style(HTML(
    '.myClass {
        font-size: 20px;
        line-height: 50px;
        text-align: left;
        font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
        padding: 0 15px;
        overflow: hidden;
        color: white;
      }
    '
  )))
  # write text
  ,tags$script(HTML('
      $(document).ready(function() {
        $("header").find("nav").append(\'<span class="myClass"> SoMa West Cleanup </span>\');
      })
     '))
  
  
  ## css style change
  ,tags$head(
    # Include custom CSS 
    # courtosy of:
    # https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example
    includeCSS("map&overlay.css")
  )
  
  ## custum css style change
  # to keep map full height in page
  # need to subtract 80px for header
  ,tags$style(
    type = "text/css"
    ,"#map {height: calc(100vh - 80px) !important;}"
  )
  
  ## output leaflet map
  ,leafletOutput(
    "map"
    ,width = "100%"
  )
  
  # add statistics overlay panel 
  # if user stat button is true
  ,conditionalPanel(
    condition = "input.TFstat == true",
    
    ############# draw overlay panel
    absolutePanel(
      # settings
      id = "controls"
      ,class = "panel panel-default"
      ,fixed = TRUE
      ,draggable = TRUE
      ,top = 80
      ,left = "auto"
      ,right = 25
      ,bottom = "auto"
      ,width = 250
      ,height = "auto"
      
      ## header          
      ,h2("Map Statistics")
      
      ###########
      # render simple graphs
      
      ,prettyToggle(
        inputId = "useScreen"
        ,label_on = "Adjusting data from screen"
        ,label_off = "Showing all data"
        # ,icon_on = icon("bar-chart", lib = "font-awesome")
        # ,icon_off = icon("remove", lib = "glyphicon")
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
      
      # total objects shown / all objects
      
      ,plotOutput(
        "overlay_lollipop"
        ,width = "220px"
        ,height = "150px" 
        # ,height = reactive({paste0(25 + (25 * (loln() - 1)),'px')})
      )
      
      # circle packer for map categories
      
      
    )
  )
  
  # map covers this
  # ,tags$div(
  #   id="cite"
  #   ,'Data compiled for '
  #   ,tags$em('Coming Apart: The State of White America, 1960-2010')
  #   ,' by Charles Murray (Crown Forum, 2012).'
  # )
  
  
)