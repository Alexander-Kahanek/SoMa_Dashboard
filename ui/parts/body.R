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
    # calls map width percentage - header size
    includeCSS("backend/css/map_height.css")
    # limits server output -- limits warnings / errors
    ,includeCSS("backend/css/shiny_output.css")
  
  )
  
  # # JS for Text after logo and sidebar button
  # ,tags$head(tags$style(HTML(
  #   '.myClass {
  #       font-size: 20px;
  #       line-height: 50px;
  #       text-align: left;
  #       font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
  #       padding: 0 15px;
  #       overflow: hidden;
  #       color: black;
  #     }
  #   '
  # )))
  # # write text next to logo
  # ,tags$script(HTML('
  #     $(document).ready(function() {
  #       $("header").find("nav").append(\'<span class="myClass"> Interactive Litter and Quality of Life Map of SoMa, San Francisco </span>\');
  #     })
  #    '))
  
  
  ,fluidRow(
    
    column(12
           
           ,fluidRow(
             align = "center"
             ,column(12
                     # ,box(width="100%", height = "5px")
                     ,h2(HTML("<b>Interactive Litter and Quality of Life Map of SoMa, San Francisco</b>"))
             )
           )
    )
  )
  
  
  ,fluidRow(
    
    column(12
           
           ,fluidRow(
             align = "center"
             ,column(12
                     ,box(width="100%", height = "5px")
                     ,h4(HTML("<b>The SoMa West community came together and mapped every issue
                              in their neighborhood. Now they're working together to fix it.
                              See project information link for more!</b>"))
             )
           )
    )
  )
  
  ,fluidRow(
    ## output leaflet map
    column(12
           ,leafletOutput(
             "map"
             ,width = "100%"
           )
           ,style='padding-left:90px; padding-right:95px;'
    )
  )
  
  ,fluidRow(
    
    column(12
            
            ,fluidRow(
              align = "center"
              ,column(12
                ,br()
                ,box(width="100%", height = "5px")
                ,h4(HTML("<b>Bin Heat Map (Adjust resolution with left hand toggle)</b>"))
              )
            )
    )
  )
  
  
  ,fixedRow(
    

    # ,textOutput("bodyText")

    
    column(12
           ,plotlyOutput(
             "heatmap"
             ,width = "100%"
           )
           ,style='padding-left:80px;'
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
      ,top = 120
      ,left = "auto"
      ,right = 25
      ,bottom = "auto"
      # ,width = 250
      ,width = 375
      ,height = "auto"
      
      ,fluidRow(
        align = "center"
        ,column(12
               ## header
               ,h4(HTML("<b>You can drag me!</b>"))
               
               
               ,actionBttn(
                 inputId = "insideOverlay",
                 label = "Close!",
                 style = "float", 
                 color = "danger"
               )
        )
      )
      
      ,fluidRow( # blank space
        align = "center"
        ,column(12
                ,br()
                ,box(width="100%", height = "5px")
                ,h5(HTML("<b>Number of items on map</b>"))
        )
      )

      ,fluidRow( # lollipop graph
        column(12
          ,plotOutput(
            "overlay_lollipop"
            ,height = "150px"
            ,width = "320px"
          )
        )
      )


      ,fluidRow( # blank space
        align = "center"
        ,column(12
               ,box(width="100%", height = "5px")
               ,h5(HTML("<b>Proportion of points on map</b>"))
        )
      )

      ,fluidRow( # proportion bar
        column(12
               ,plotOutput(
                 "overlay_fillbar"
                 ,height = "75px"
                 ,width = "320px"
               )
        )
      )



    )
    
    ,h6(HTML('<b>Data collected by Rubbish, page created by Alexander Kahanek.</b>'))
    # # sidebar will cover this text
    # ,tags$div(
    #   id="cite"
    #   ,HTML('<b>Data collected by Rubbish, page created by Alexander Kahanek.</b>')
    #   # ,align = "center"
    # )
  )
  
  

  
)
