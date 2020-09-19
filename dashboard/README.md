# Dashboard Structure

This is the file structure of the dashboard, including what is included in each file.

* `app.R`
  + main: file calls main header files and created the application
  + contains source files and creates shiny application
    - `global.R`
    - `ui.R` , which is local
    - `server.R`
    
* `global.R`
  + declares all global libraries, lists, and data
  + contains libraries for all graphs
    - dplyr (for all data manipulation)
    - reticulate (for python integration)
    - created python scripts (coordinate binning)
    - leaflet (map) [leaflet, leaflet.providers]
    - ggplot (overlays) [ggplot2, ggthemes]
    - plotly (heatmap) [heatmaply, plotly, RColorBrewer]
  + declare global lists
    - object type list
    - issue type list
    - other type list
    - all labels
    - street labels
    - objects, issues, all types, zoning classification, streets
      + hex color codes for entire dashboard
+`/server/`
  + `server.R`
    - contains library: shiny
    - creates interactive server
      + reactive element:
        - CoordInBounds: scrapes map screen data
          - idea from: https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example
        - percentage bar creation
        - lollipop chart creation
      + elements: text outputs
      + interactive element:
        - leaflet map creation
        - download data button
      + reactive: interactive: element: 
        - plotly heatmap creation


* `/ui/`
  + folder stores all ui elements
  + `ui.R`
    - stitches together header, sidebar, and body ui code
    - contains source files for ui parts
  + `theme.R`
    - holds all theming options for entire dashboard
      - https://github.com/nik01010/dashboardthemes
  + `/parts/`
    + `ui.header.R`
      - creates user interface header
        + creates logo
        + creates download data, and project info button
    + `ui.sidebar.R`
      - creates user interface sidebar element
        + creates user input options
          - data filtering types
          - map coloring options
          - bin map x and y changes
          - reactive grapgs from map toggle
    + `ui.body.R`
      - contains 2 libraries utilized in the UI
        + shinydashboard
        + dashboardthemes
      - css calls:
        + `map&overlay.css` alters css for leaflet map and overly element
        + `column_limiter.css` limits column sizes when re-adjusting screen.
        + `map_height.css` this allows the map height to be changed into percentages
        + `shiny_output.css` this limits the warnings and fake-error messages outputted by packages
      - HTML calls:
        + `google_analytics.html` this isnt included in the GitHub, but it connect the dashboard to Google Analytics
      - JS calls:
        + `tracking.js` this connects dashboard elements to GA, to grab usage data
        + `window_dimentions.js` relays window size information back to dashboard
      - renders elements:
        + text elements
        + leaflet output
        + plotly heatmap output
        + overlay panel
          - lollipop chart output
          - progress bar output

+ `/raw/`
  + this holds all the raw data and cleaning scripts
    - the true original data file is not included, as it includes personal information
  + `clean_rubbish.csv`
    + this is the cleaned data set used inside the dashboard
  + `/OG/`
    + `/shape_files/`
      - this stores the commercial and redidential shape files used for zoning classification
      - http://geojson.io/
    - `one_clean_data.R`
      + the first script that the raw data is pushed through
      + this cleans columns, feature names, fixes dates
    - `two_flatten&classify.py`
      + the second script that the data is pushed through
      + this flattens the data points, and does the zoning classification
    + `Rclean_rubbish.csv`
      + this is the data file that is exported to users in the dashboard


* `/backend/`
  + folder stores all scripts used for the webpage backend
  * `/css/`
    + `map&overlay.css`
      + custom fonts for overlay
      + background style for overlay
      + map background style
      + variable height for map
    + `column_limiter.css`
      + overrides and creates a mininum width for columns to adjust
    + `map_height.css`
      + allows the leaflet map to be converted into percentage of screen
    + `shiny_output.css`
      + limits error and warning messages outputted into console
  + `/js/`
    - `tracking.js`
      + Google Analyitics tracking interactive elements
    + `window_dimensions.js`
      + grabs the screens dimensions (not currently in play)
  + `html`
    - `google_analytics.html`
      + Google Analytics tracking code
    - `min&max_viewport.html`
      + limits min and max size of dashboard display
  + `/python/`
    + `bin_geo.py`
      - no dependencies
      - script take latitude and longitude data and creates bins based on user input
      
* `/www/`
  + stores all images and icons used in dashboard
