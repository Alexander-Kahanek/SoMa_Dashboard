library(shiny)

#############################################################
# creating server


server <- function(input, output)({
  
  ####################################################
  ## scraping user input
  # this will be used for controlling 
  # ,the (lat) & (long) range of geocoords
  # ,the variable on the overlay plot
  ## manipulating data
  # need to manip dataframe to only contain datapoints
  # that are displayed on the screen, so math.
  #
  # math proof comp. sci. style (for funsies)
  # if:
  # x_[a,n,b], y_[a,n,b] exists in world
  # s.t. x_[1, .., n], y_[1, .., n] exists 
  # for all x that exist on screen
  # then:
  # x_a <= x_n <= x_b 
  # and y_a <= y_1n <= y_b
  coordInBounds <- reactive({
    if(input$useScreen){
      if(is.null(input$map_bounds)){
        # no user map displayed
        return(onscreen_data[FALSE,])
      }
      # user screen map bounds
      bounds <- input$map_bounds 
      # getting [x_a, x_b]
      long_rng <- range(bounds$east, bounds$west)
      # scraping [y_a, y_b]
      lat_rng <- range(bounds$north, bounds$south)
      
      # subset dataframe
      # for overlay plots
      onscreen_data <- raw %>%
        subset(
          lat >= lat_rng[1]
          &lat <= lat_rng[2]
          &long >= long_rng[1]
          &long <= long_rng[2]
        )
    }
  })
  
  output$bodyText <- renderText({ 
    paste0("This is an interactive webpage!"
           ," If you move the map, all the graphs will update"
           ,", and if you change the sliders above, the granularity of the graph below will change!"
           )
  })
  
  output$blankspace <- renderText({ 
    "     "
  })
  
  observeEvent(
    input$popup_info
    ,{
      
      showModal(
        modalDialog(
          title = HTML("<b>Rubbish SoMa West Cleanup</b>")
  
          ,div(HTML(
            "
            &nbsp;&nbsp;&nbsp;&nbsp; In August of 2019 before the start of services of the CBD a community lead audit of the
neighborhood and with the help of over 20 residents and volunteers close to 30,000 points of
data were gathered based on neighborhood concerns. The visualizations that you see here are
a representation of all of the concerned logged in a two week stretch. This data was used to
determine which areas of the district needed more attention, to acquire funding for the
placement of 53 brand new trash receptacles. This data will also serve as benchmark for the
services provided by the CBD once a follow up audit is conducted.
            ")
            , style = "color:black")
          ,br()
          
          ,div(HTML(
            "
          &nbsp;&nbsp;&nbsp;&nbsp; The SoMa West CBD is the largest community benefit district in all of San Francisco, and
started services in January of 2020. The CBD serves the western portion of the South of Market
(SoMa) neighborhood that stretches from the intersections of Mission Street and Van Ness Ave.
East to 6th Street. The neighborhood has a rich makeup, including: sprawling new residential
development, the Leather and LGBTQ Cultural District, many large tech company offices, some
of the only big box stores in the city of San Francisco, as well as Highway 80 that leads to the
San Francisco Bay Bridge. 
<a href='https://medium.com/rubbish-love/san-francisco-leverages-tech-to-clean-up-rubbish-d2eceef18e56'>Read more about the audit here!</a>
          ")
            ,style = "color:black")
          ,br()
          
          ,div(HTML(
            "
            &nbsp;&nbsp;&nbsp;&nbsp; This data was then used in collaboration with Rubbish and Alexander Kahanek
            to create this dashboard! The original dataset is available for public use, and all the code for the dashboard
            is available on GitHub.
            ")
            , style = "color:black")
          ,br()
          
          ,HTML('<a href="https://github.com/Alexander-Kahanek/SoMa_Dashboard" target="_blank"><center><img src="GitHub-Mark-64px.png"></center></a>')
          )
      )
    }
  )
  
  
output$downloadData <- downloadHandler(
  filename = function() {
    paste('rubbish_soma_west-', Sys.Date(), '.csv', sep='')
  },
  content = function(con) {
    write.csv(read.csv("raw/OG/RShiny_soma_export.csv"), con, row.names=FALSE)
  }
)
  
  
  #################
  # creating graphs
  
  
  ###### 1. Leaflet Map
  output$map <- renderLeaflet({
    
    # coord for rough middle of plot
    # for map reboot, in middle of types chosen
    viewLatLong <- raw %>%
      summarise(
        meanlat = mean(lat)
        ,meanlong = mean(long)
      )
    
    # can add option for middle of user screen
    # based on global option for screen adjust
    
    ## mutate data for user input of object types
    dfObjs <- raw %>%
      subset(type %in% input$usrObjs) 
    
    dfissues <- raw %>% 
      subset(type %in% input$usrIssues)
    
    
    map <- dfObjs %>%
      # send data to leaflet map
      leaflet(
        
        ## global map settings
        # size settings
        width = "100%"
        ,height = "100%"
      ) %>%
      # this limits the user from dragging off california, though they can still zoom out
      # setMaxBounds(lng1 = -124.409591, lat1 = 32.534156, lng2=-114.131211, lat2=42.009518) %>%
      setView(
        # set initial view to middle of data
        lng= viewLatLong[['meanlong']]
        ,lat= viewLatLong[['meanlat']]
        # initial zoom, fits all points
        ,zoom= 15 # 15.2
      ) %>%
      addProviderTiles(
        # backgrounds
        # "CartoDB.DarkMatter"
        # "Stamen.Toner"
        "CartoDB.Voyager"
        # "Stadia.Outdoors"
      ) 
    
    cols <- c()
    labs <- c()
    
    
    if (length(input$usrObjs) != 0){
      ######### objects ############
      
      if (input$usrColor == "ObjsIssues"){
        
        colorsort = "itemsTagged"
        color = ObjsIssueColors[[1]]
        label = "Objects"
        
        colObjs <- colorBin(
          palette = c(color, color)
          ,domain = c(1,250)
        )
        
        cols <- cols %>% append(color)
        labs <- labs %>% append(label)
      }
      else if (input$usrColor == "Types"){
        
        colorsort = "type"
        color = typeColors[which(objTypes %in% input$usrObjs)]
        label = allLabels[which(objTypes %in% input$usrObjs)]

        
        colObjs <- colorFactor(
          palette = color
          ,levels = objTypes[input$usrObjs %in% objTypes]
        )
        
        cols <- cols %>% append(color)
        labs <- labs %>% append(label)
      }
      else if (input$usrColor == "Streets"){
        
        colorsort = "street"
        color = streetColors
        label = streetLabels
        
        colObjs <- colorFactor(
          palette = color
          ,levels = streetLabels
        )
        
        cols <- cols %>% append(color)
        labs <- labs %>% append(label)
      }
      else if (input$usrColor == "classification"){
        
        colorsort = "classification"
        color = classificationColors
        label = c("Residential", "Commercial", "Unclassified")
        
        colObjs <- colorFactor(
          palette = color
          ,levels = classificationLabels
        )
        
        cols <- cols %>% append(color)
        labs <- labs %>% append(label)
      }
      
      map <- map %>%
        addCircles(
          # circle settings
          lng = ~long
          ,lat = ~lat
          ,radius = ~itemsTagged*0.2
          ,color = ~colObjs(dfObjs[,colorsort])
        )
    }
    
    if (length(input$usrIssues) != 0){
      ######### issues ##############
      
      if (input$usrColor == "ObjsIssues"){
        
        colorsort = "itemsTagged"
        color = ObjsIssueColors[[2]]
        label = "Issues"
        
        colissues <- colorBin(
          palette = c(color, color)
          ,domain = c(1,250)
        )
        
        cols <- cols %>% append(color)
        labs <- labs %>% append(label)
      }
      else if (input$usrColor == "Types"){
        
        colorsort = "type"
        color = typeColors[which(input$usrIssues %in% issueTypes) + 6]
        label = allLabels[which(input$usrIssues %in% issueTypes) + 6]
        
        colissues <- colorFactor(
          palette = color
          ,levels = issueTypes[input$usrIssues %in% issueTypes]
        )
        
        cols <- cols %>% append(color)
        labs <- labs %>% append(label)
      }
      else if (input$usrColor == "Streets"){
        
        colorsort = "street"
        color = streetColors
        label = streetLabels
        
        colissues <- colorFactor(
          palette = color
          ,levels = streetLabels
        )
      }
        else if (input$usrColor == "classification"){
          
          colorsort = "classification"
          color = classificationColors
          label = c("Residential", "Commercial", "Unclassified")
          
          colissues <- colorFactor(
            palette = color
            ,levels = classificationLabels
          )
      }
      
      map <- map %>% 
        addRectangles(
          # rectangle settings
          lng1 = ~dfissues$long
          ,lat1 = ~dfissues$lat
          ,lng2 = ~dfissues$long + 0.0001
          ,lat2 = ~dfissues$lat + 0.0001
          ,color = ~colissues(dfissues[,colorsort])
        )
    }
    
    ##### legend
    if (input$usrColor != "Streets"){
      map <- map %>% 
        addLegend(
          position = "bottomleft"
          ,colors = cols
          ,labels = labs
        )
    }
    
    map
  })
  
  
  ###### 2. Heatmap 
  output$heatmap <- renderPlotly({
    
    allusrtype <- input$usrObjs
    allusrtype <- allusrtype %>%  append(input$usrIssues)
    
    if (input$useScreen){
      
      if(coordInBounds() %>% nrow() == 0){
        # nocoordinates displayed
        return (NULL)
      }
      
      usrdata <- coordInBounds() %>% 
        subset(type %in% allusrtype)
    }
    else{
      usrdata <- raw %>% 
        subset(type %in% allusrtype)
    }
    
    usrmatrix <- script_bins(
      lats = usrdata$lat
      ,lngs = usrdata$long
      ,xbins = as.numeric(input$usrxbins)
      ,ybins = as.numeric(input$usrybins)
    )
    
    usrmatrix <- do.call("rbind",usrmatrix)
    
    bgcolor = "grey"
    
    colors <- brewer.pal(9, "RdPu")[c(5:9)]
    # colors[1] <- "#ffffff"
    
    usrmatrix %>% 
    apply(1:2, function(x){return (ifelse(x==0, NA, x))}) %>% 
      heatmaply(
        plot_method = "plotly"
        ,colors = colorRampPalette(colors)
        ,Rowv=FALSE
        ,Colv=FALSE
        ,draw_cellnote = FALSE
        ,dendogram = "none"
        ,show_dendrogram = c(FALSE, FALSE)
        ,dend_hoverinfo = FALSE
        ,grid_color =  "#ffffff"
        ,titleX = FALSE
        ,titleY = FALSE
        ,showticklabels = c(FALSE, FALSE)
        ,hide_colorbar = TRUE
        ,grid_gap = 1
        ,na.value = "#ffffff"
      ) %>% 
      layout(paper_bgcolor='transparent') %>% 
      # config(displayModeBar = F) %>% 
      layout(width = (1*as.numeric(input$dimension[1])), height = 0.4*as.numeric(input$dimension[2]))#(height = 300, width = "1000px")
  })
 
  
    
  ###################################################################
  # overlay plots
  
  ###### 2. lollipop count graph
  output$overlay_lollipop <- renderPlot({
    
    
    if(input$useScreen){
      
      if(coordInBounds() %>% nrow() == 0){
        # no coordinates displayed
        return (NULL)
      }
      usrdata <- coordInBounds()
    }
    else{
      usrdata <- raw
    }
    
    
    # data manipulation
    loldata <- usrdata %>% 
      subset(type %in% input$usrObjs) %>% 
      group_by(pretty_type) %>% 
      summarise(
        totItems = sum(itemsTagged)
      ) %>% 
      arrange(totItems) %>% 
      mutate(
        order = row_number()
      )
    
    # create lollipop from ggplot
    lollipop <- loldata %>% 
      ggplot() +
      # ggtitle("objects on map") + 
      xlab(NULL) + 
      ylab(NULL) + 
      geom_segment(
        # stem of lollipop
        aes(
          x=order, xend=order
          ,y=0, yend=totItems
        )
        ,color="#F01382"
        ,size = 3) + # size 1.5 if using point
      # geom_point(
      #   # point on lollipop
      #   aes(
      #     x=order
      #     ,y=totItems
      #     ,color="#F01382"
      #   )
      #   ,size=5
      # ) +
      theme_classic() + 
      theme(
        axis.text=element_text(size=13)
        # ,axis.title=element_text(size=16,face="bold")
        ,plot.margin=unit(c(0.75, 0.75, 0.5, 0.5),"cm")
        ,rect = element_rect(fill = "transparent")
        ,axis.line.y = element_line(colour = "white")
      ) + 
      theme(legend.position = "none") + 
      coord_flip() + 
      scale_x_continuous(
        NULL
        # fix y labels
        ,breaks = loldata$order
        ,labels = loldata$pretty_type
      ) + 
      scale_y_discrete(
        NULL
        # fix x limits and labels
        ,limits = c(0
          # ifelse(min(loldata$totItems) != max(loldata$totItems)
          #        ,min(loldata$totItems)
          #        ,0)
          ,ceiling(max(loldata$totItems)*1.0)
        )
      )
    
    if (nrow(loldata) != 0){
      lollipop
    }
    
  }, bg="transparent")
  
  
  ###### 3. fill graph
  output$overlay_fillbar <- renderPlot({
    
    allusrtype <- input$usrObjs
    allusrtype <- allusrtype %>%  append(input$usrIssues)
    
    if(input$useScreen){
      
      if(coordInBounds() %>% nrow() == 0){
        # nocoordinates displayed
        return (NULL)
      }
      
      usrdata <- coordInBounds()
      
      maxitems <- raw %>% 
        subset(type %in% allusrtype) %>%
        summarise(total = sum(itemsTagged)) %>% 
        as.numeric()
    }
    else{
      usrdata <- raw
      
      maxitems <- raw %>% 
        summarise(total = sum(itemsTagged)) %>% 
        as.numeric()
    }
    
    current_items <- usrdata %>% 
      subset(type %in% allusrtype) %>% 
      summarise(total = sum(itemsTagged)) %>% 
      as.numeric()
    
    percent <- paste0(ceiling(current_items/maxitems*100),"%")
    
    percentage_gragh <-  ggplot() +
      # ggtitle("Proportion of Items on Map") +
      xlab(NULL) + 
      ylab(NULL) + 
      geom_segment(
        aes(
          x=percent, xend=percent
          ,y=0, yend=maxitems
        )
        ,color = "#DBDBDB"
        ,size=3
      ) +
      geom_segment(
        aes(
          x=percent, xend=percent
          ,y=0, yend=current_items
          )
        ,color = "#F01382"
        ,size=6
        ) +
      theme_classic() +
      theme(
        axis.text=element_text(size=13)
        ,rect = element_rect(fill = "transparent")
        ,axis.line.y = element_line(colour = "white")
        # ,plot.margin=unit(c(0,0,-12,-5), "mm")
        # ,axis.text = element_blank()
        # ,axis.ticks.length = unit(0, "mm")
        ) + 
      theme(legend.position = "none") +
      coord_flip() + 
      scale_y_continuous(
        NULL
        # fix x limits and labels
        ,limit = c(
          0, maxitems
        )
        ,breaks = c(current_items)
      )
      
    percentage_gragh
  }, bg="transparent")
  
})
