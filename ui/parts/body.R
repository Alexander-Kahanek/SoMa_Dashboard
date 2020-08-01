library(shinydashboard)
library(dashboardthemes)
source('ui/theme.R')


#############
# create body
body <- dashboardBody(
  
  custom_theme
  
  ,tags$head(
    # grabs window dimensions for heatmaply object size
    tags$script(src='backend/js/window_dimentions.js')
    # controls map and overlay settings
    ,includeCSS("backend/css/map&overlay.css")
    # controls column adjustment priorities
    ,includeCSS("backend/css/column_limiter.css")
    # controls google analytics header
    ,includeHTML("backend/html/google_analytics.html")
    # tracking elements and sending to google analytics
    ,includeScript("backend/js/tracking.js")
  )
  
  
  ,tags$style(
    # limits page to maximun and mininum size  
    includeHTML("backend/html/min&max_viewport.html")
    # calls map width percentage - header size
    ,includeCSS("backend/css/map_width.css")
    # limits server output -- limits warnings / errors
    ,includeCSS("backend/css/shiny_output.css")
  
  )
  
  # JS for Text after logo and sidebar button
  # ,tags$head(tags$style(HTML(
  #   '.myClass {
  #       font-size: 20px;
  #       line-height: 50px;
  #       text-align: left;
  #       font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
  #       padding: 0 15px;
  #       overflow: hidden;
  #       color: white;
  #     }
  #   '
  # )))
  # write text next to logo
  # ,tags$script(HTML('
  #     $(document).ready(function() {
  #       $("header").find("nav").append(\'<span class="myClass"> SoMa West Cleanup </span>\');
  #     })
  #    '))
  
  ,fluidRow(
    ## output leaflet map
    column(12
           ,leafletOutput(
             "map"
             ,width = "100%"
           )
    )
  )
  
  ,fluidRow(
    
    column(12
            
            ,fluidRow(
              column(12
                ,sliderTextInput(
                  inputId = "usrxbins"
                  ,width = "98%"
                  ,selected = 50
                  ,label = "Move this slider to change the number of columns."
                  ,choices = c(seq(1,200, b=1))
                  ,grid = FALSE
                )
              )
            )
    )
  )
  
  
  ,fixedRow(
    
    column(2
      ,knobInput(
        inputId = "usrybins"
        ,label = "Number of rows"
        ,height = "100px"
        ,width = "100px"
        ,value = 50
        ,min = 0
        ,max = 200
        ,displayPrevious = TRUE
        ,lineCap = "round"
        ,fgColor = "#428BCA"
        ,inputColor = "#428BCA"
      )
      
      ,textOutput("bodyText")
    )
    
    ,column(10
           ,plotlyOutput(
             "heatmap"
             ,width = "100%"
           )
    )
           
  )
  
  
  # add statistics overlay panel 
  # if user stat button is true
  ,conditionalPanel(
    condition = "input.insideOverlay == false | input.sidebarOverlay == true",
    
    ############# draw overlay panel
    absolutePanel(
      # settings
      id = "controls"
      ,class = "collapse in"
      ,fixed = TRUE
      ,draggable = TRUE
      ,top = 80
      ,left = "auto"
      ,right = 25
      ,bottom = "auto"
      ,width = 250
      ,height = "auto"
      
      ## header          
      ,h4("You can drag me!")
      
      ,prettyToggle(
        inputId = "insideOverlay"
        ,label_on = "Use the sidebar close button"
        ,label_off = "Click to close"
        ,icon_on = icon("bar-chart", lib = "font-awesome")
        ,icon_off = icon("remove", lib = "glyphicon")
        ,value = FALSE
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
      
      ,fluidRow(
        column(12
          ,plotOutput(
            "overlay_lollipop"
            ,width = "220px"
            ,height = "150px" 
            # ,height = reactive({paste0(25 + (25 * (loln() - 1)),'px')})
          )
        )
      )
      
      
      ,fluidRow(
        column(12
               # circle packer for map categories
               ,plotOutput(
                 "overlay_fillbar"
                 ,width = "220px"
                 ,height = "75px" 
                 # ,height = reactive({paste0(25 + (25 * (loln() - 1)),'px')})
               )
        )
      )
      
      
      
    )
  )
  
  # sidebar will cover this text
  ,tags$div(
    id="cite"
    ,'Data collected by Rubbish, page created by Alexander Kahanek'
  )

  
)
