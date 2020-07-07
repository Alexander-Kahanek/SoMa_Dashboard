# Dashboard

File Structure, will be changed into a graphic plot, when finished with application.

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
      + creates user interface header
        - creates logo
        - creates info button
    - ui.sidebar.R
      + creates user interface sidebar element
        - HTML header colors
        - ui output option
          + add a mobile option
        - creates user input options
          + toggle overlay graphs
          + object type check boxes
          - issue type check boxes
          + color by radio button
    - ui.body.R
      + css: map&overlay.css
        - alters css for leaflet map and overly element
      + renders elements:
        - manual css changes
          + change to files
        - leaflet output
        - two sliders for heatmap
        - plotly heatmap output
        - overlay panel
          + button to turn off reactive map scraping
          + lollipop chart output
          + progress bar output

* server.R
  + contains library: shiny
  + creates interactive server
    - reactive element: scrapes map screen data
    - elements: text outputs
      + create python function file for this
    - interactive element: leaflet map creation
    - reactive: interactive: element: plotly heatmap creation
    - creates overlay output graphs
      + reactive element: lollipop chart creation
      + reactive element: percentage bar creation
    
