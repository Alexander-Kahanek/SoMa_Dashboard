#############################################################
# creating server


server <- function(input, output)({
  
  output$overlay_text <- renderText({ 
    "
    Move your map to change the graphs!
    "
  })
  
  observeEvent(
    input$popup_info
    ,{
      showModal(
        modalDialog(
          title = "Rubbish SoMa West Cleanup"
          ,p(
          "
          This was a cleanup performed by the Rubbish team, to 
          get a snapshot of group objects in SoMa west, CA. 
          "
          )
          ,p(
            "
            Hello this is the second paragraph.
            "
          )
        )
      )
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
    
    
    # add more color optiopns
    # obj type
    # area classification
    
    
    map <- dfObjs %>%
      # send data to leaflet map
      leaflet(
        
        ## global map settings
        # size settings
        width = "100%"
        ,height = "100%"
      ) %>%
      setView(
        # set initial view to middle of data
        lng= viewLatLong[['meanlong']]
        ,lat= viewLatLong[['meanlat']]
        # initial zoom, fits all points
        ,zoom= 15.2
      ) %>%
      addProviderTiles(
        # backgrounds
        "CartoDB.DarkMatter"
        # ,"Stamen.Toner"
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
        color = typeColors[which(input$usrObjs %in% objTypes)]
        label = allLabels[which(input$usrObjs %in% objTypes)]
        
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
  })
    
  
  ###### 2. lollipop count graph
  output$overlay_lollipop <- renderPlot({
    
    if(input$useScreen){
      
      if(coordInBounds() %>% nrow() == 0){
        # nocoordinates displayed
        return (NULL)
      }
      usrdata <- coordInBounds()
    }
    else{
      usrdata <- raw
    }
    
    
    # data manipulation
    pdata <- usrdata %>% 
      subset(type %in% input$usrObjs) %>% 
      group_by(type) %>% 
      summarise(
        totItems = sum(itemsTagged)
      ) %>% 
      arrange(totItems) %>% 
      mutate(
        order = row_number()
        # change type names for output
        ,type = ifelse(type == objTypes[1]
                       ,"Litter"
                       ,ifelse(type == objTypes[2]
                               ,"Grease&Gum"
                               ,ifelse(type == objTypes[3]
                                       ,"Graffitti"
                                       ,ifelse(type == objTypes[4]
                                               ,"Needles"
                                               ,ifelse(type == objTypes[5]
                                                       ,"Glass"
                                                       ,ifelse(type == objTypes[6]
                                                               ,"Poop&Urine"
                                                               ,"Other"
                                                       )
                                               )
                                       )
                               )
                       )
        )
      )
    
    # create lollipop from ggplot
    lollipop <- pdata %>% 
      ggplot() +
      geom_segment(
        # stem of lollipop
        aes(
          x=order, xend=order
          ,y=0, yend=totItems
        )
        ,color="#F6A2FC"
        ,size = 1.5) +
      geom_point(
        # point on lollipop
        aes(
          x=order
          ,y=totItems
          ,color="#E935f2"
        )
        ,size=5
      ) +
      theme_hc() + 
      theme(legend.position = "none") + 
      coord_flip() + 
      scale_x_continuous(
        ""
        # fix y labels
        ,breaks = pdata$order
        ,labels = pdata$type
      ) + 
      scale_y_discrete(
        "objects on map"
        # fix x limits and labels
        ,limits = c(
          ifelse(min(pdata$totItems) != max(pdata$totItems)
                 ,min(pdata$totItems)
                 ,0)
          ,ceiling(max(pdata$totItems)*0.45)
          ,ceiling(max(pdata$totItems)*0.9)
        )
      )
    
    # loln(length(unique(pdata$type)))
    # values$loln <- length(unique(pdata$type))
    # print(loln())
    
    if (length(input$usrObjs) != 0){
      lollipop
    }
    
  })
  
  
  
})
