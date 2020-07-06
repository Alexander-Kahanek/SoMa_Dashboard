###############
# create headbar  
header <- dashboardHeader(
  # windowTitle = 'Rubbish SoMa West Cleanup'
  # ,title = "Rubbish SoMa West Cleanup"
  # ,title=div(img(src="rubbish_logo.png"))
  title = tags$a(
    href='https://www.rubbish.love/'
    ,target = '_blank'
    ,tags$img(
      src='rubbish_logo.png'
      ,height='25',width='200px'
    )
  )
  
  ,titleWidth = "230px"
  
  ,tags$li(actionLink("popup_info", label = " Project Information", icon = icon("info")),
           class = "dropdown")
)