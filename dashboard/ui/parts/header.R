library(shinydashboard)
###############
# create headbar  
header <- dashboardHeader(
  # windowTitle = 'Rubbish Dashboard'
  # ,title = "Rubbish SoMa West Cleanup"
  # ,title=div(img(src="rubbish_logo.png"))
  title = tags$a(
    href='https://www.rubbish.love/'
    ,target = '_blank'
    ,tags$img(
      src='header_logo.png'
      # ,height='35px',width='200px'
    )
  )
  
  ,titleWidth = "230px"
  
  ,tags$li(
    downloadLink(
      'downloadData'
      ,label = tags$img(
        src='download_button.png'
        # ,height='18px',width='200px'
      )
      )
    ,class="dropdown"
  )
  
  ,tags$li(
    
    actionLink(
      "popup_info"
      ,label = tags$img(
          src='information_button.png'
          # ,height='18px',width='200px'
      )
      # ,icon = icon("info")
      # ,icon = img()
      )
    ,class = "dropdown"
    )
)