# Dashboard

Files:

* app.R
  + main: file calls main header files and created the application
  + contains source files and creates shiny application
    - global.R
    - ui.R , which is local
    - server.R
    
* global.R
  + declares all global libraries, lists, and data
  + contains libraries for all graphs
    - reticulate (for python integration)
    - created python scripts (coordinate binning)
    - leaflet (map)
    - ggplot (overlays)
    - plotly (heatmap)
  + declare global lists
    - object type list
    - issue type list
    - other type list
    - all labels in a list
    - objects, issues, others, hex color
    - colors by all type list
    - all street colors
    - all street labels
    
* ui.R
  + stitches ui parts together
  + contains source files for ui parts
    - ui.header.R
    - ui.sidebar.R
    - ui.body.R
      + has texts, css changes, map, heatmap, overlay

* server.R
  + contains library: shiny
  + creates interactive server
    
