####### ALL LIBRARIES USED ###########
###### DATA MANIPULATION ######
options(stringsAsFactors = FALSE)
library(dplyr) # for main data manipulations

library(leaflet) # for leaflet map
library(leaflet.providers) # leaflet backgrounds

library(ggplot2) # for overlay plots
library(ggthemes) # overlay themes

library(heatmaply) # for heatmap
library(plotly) # for heatmaply rendering, options
library(RColorBrewer) ## get rid of

library(reticulate) # for python integration
source_python('backend/python/bin_geo.py') # coordinates bin calculator

# supress messages not covered in css file
options(warn = -1) 
options(dplyr.summarise.inform=FALSE)

#############################################################
# global data

# base csv data
# cleaned via raw/clean_script.R
# used for base map data layer
# will be manipulated later on
raw <- read.csv("raw/clean_rubbish.csv") %>% 
  subset(lat < 37.785)

# dataframe for manipulation of the raw df to store
# the data points that appear only on the screen.
# used for overlat plot graphs
onscreen_data <- raw


#############################################################
# global lists

# all objects list
objTypes <- c(
  "litter" # 1
  ,"greaseGumStains" # 2
  ,"graffiti" # 3
  ,"needles" # 4
  ,"brokenGlass" # 5
  ,"poopUrine"# 6
)

# all issues list
issueTypes <- c(
  "trashCanIssue" # 7
  ,"treeIssueWeeds"# 8
  ,"otherIssue" # 9
)

# currently not using
# all other list
otherTypes <- c(
  "streetFurniture" # 10
  ,"emptyTreeHole" # 11
  ,"largeItem" # 12
)


# total: 12

#############
# labels list

allLabels <- c(
  "Litter" # 1
  ,"Grease and Gum Stains" # 2
  ,"Graffiti" # 3
  ,"Needles" # 4
  ,"Broken Glass" # 5 
  ,"Poop and Urine" # 6
  ,"Trash Can Issue" # 7
  ,"Tree Issue" # 8
  ,"Other Issue" # 9
  ,"Street Furniture" # 10
  ,"Empty Tree Hole" # 11
  ,"Large Item" # 12
)

##############
# colors list
# rubbish E935f2 
# lightpink F4B2F8 | F6A2FC
# orange F49D04

ObjsIssueColors <- c(
  "#E935f2" # objects
  ,"#F49D04" # issues
  ,"#82F525" # other
)

typeColors <- c(
  # pinks, blues
  "#E935F2" # litter
  ,"#F38EF8" # greaseGumStains
  ,"#A90E75" # graffiti
  ,"#780EA9" # needles
  ,"#A757CC" # brokenGlass
  ,"#6363BB" # poopUrine
  # oranges, reds, yellos
  ,"#F49D04" # trashCanIssue
  ,"#EF0E07" # treeIssueWeeds
  ,"#EFE816" # otherIssue
  # greens
  ,"#82F525" # streetFurniture
  ,"#118B21" # emptyTreeHole
  ,"#54BC81" # largeItem
  
)


streetColors <- c(
  # 72 hex colors
  "#E935F2", "#800000", "#008000", "#808000" # 1 - 4
  , "#000080", "#800080", "#008080", "#ff0000" # 5 - 8
  , "#00ff00", "#ffff00", "#0000ff", "#ff00ff" # 9 - 12
  , "#00ffff", "#005fff", "#005f00", "#008787" # 13 - 16
  , "#00d700", "#00d7d7", "#00d7ff", "#00ff87" # 17 - 20
  , "#00ffff", "#5f005f", "#5f0000", "#5f5f00" # 21 - 24
  , "#5f00d7", "#5f00ff", "#5f5f87", "Chartreuse4" # 25 - 28
  , "#5fafd7", "#5fd7ff", "#5fffff", "#87005f" # 29 - 32
  , "#5fd700", "#870000", "#878700", "#87af87" # 33 - 36
  , "#5fd7d7", "#8700ff", "#87875f", "#87ff00" # 37 - 40
  , "#5fff00", "#af5fd7", "#87ffaf", "#afaf00" # 41 - 44
  , "#875f00", "#afafd7", "#afd7d7", "#af8700" # 45 - 48
  , "#af00af", "#af5f00", "#d7875f", "#d700ff" # 49 - 52
  , "#afffff", "#afff87", "#d70000", "#d75f00" # 53 - 56
  , "#d7af87", "#d7afff", "#d7af5f", "#d75faf" # 57 - 60
  , "#ff0087", "#ff5f00", "#ffffd7", "#ffd700" # 61 - 64
  , "#ffd7d7", "#ffd7ff", "#afff00", "#ffafd7" # 65 - 68
  , "#d7ff00", "#d7afd7", "#d7d7d7", "#767676" # 69 - 72
)

streetLabels <- raw$street %>% unique()
