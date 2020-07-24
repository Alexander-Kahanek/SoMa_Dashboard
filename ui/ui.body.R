library(shinydashboard)
library(dashboardthemes)
source('ui/ui.theme.R')


#############
# create body
body <- dashboardBody(title="Browser title"
  
  ,custom_theme
  
  # stop warnings in console
  ,tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
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
  
  ## css style change
  ,tags$head(
    # Include custom CSS 
    # courtosy of:
    # https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example
    includeCSS("css/map&overlay.css")
    ,includeCSS("css/column_limiter.css")
  )
  
  ## custum css style change
  # to keep map and heatmat full height in page
  # need to subtract 80px for header
  ,tags$style(
    type = "text/css"
    ,"#map {height: calc(50vh - 80px) !important;}"
  )
  
  
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
              column(5
                ,sliderTextInput(
                  inputId = "usrxbins"
                  ,selected = 50
                  ,label = "How many x-axis bins do you want?"
                  ,choices = c(seq(1,200, b=1))
                  ,grid = FALSE
                )
                
                # ,knobInput(
                #   inputId = "usrxbins"
                #   ,label = "x-axis bins"
                #   ,height = "100px"
                #   ,width = "100px"
                #   ,value = 50
                #   ,min = 0
                #   ,max = 200
                #   ,displayPrevious = TRUE
                #   ,lineCap = "round"
                #   ,fgColor = "#428BCA"
                #   ,inputColor = "#428BCA"
                # )
              )
              
              ,column(6
                # ,sliderTextInput(
                #   inputId = "usrybins"
                #   ,selected = 65
                #   ,label = "How many y bins do you want?" 
                #   ,choices = c(seq(1,200, b=1))
                #   ,grid = TRUE
                # )
                ,textOutput("bodyText")
                
              )
            )
    )
  )
  
  
  # ,fluidRow(
  #   column(12
  #          
  #          # ,textOutput("bodyText")
  #          
  #   )
  # )
  
  
  ,fixedRow(
    
    column(2
      ,knobInput(
        inputId = "usrybins"
        ,label = "y-axis bins"
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
        ,label_on = "Use the sidebar close button!"
        ,label_off = "Close me!"
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
