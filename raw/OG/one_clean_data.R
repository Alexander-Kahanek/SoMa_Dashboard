# CREATED BY: Alexander Kahanek

####### ALL LIBRARIES USED ###########
options(stringsAsFactors = FALSE)
library(dplyr)
library(lubridate)

####### HYPERPARAMETERS ##############
FIN = 'OG/SoMaWestRShiny.csv'
FOUT = "OG/Rclean_rubbish.csv"

######################################
# script starts below ################

read.csv(FIN) %>% 
  mutate(
    date = as.Date(time,
                   format = "%m/%d/%Y"),
    time_stamp = parse_date_time(time,
                           orders = "%m/%d/%Y, %I:%M:%S %p"),
    day = wday(date, label=TRUE)
  ) %>% 
  subset(select = -c(photoURL, id, time)) %>% 
  mutate(
    pretty_type = ifelse(type == objTypes[1]
                   ,"Litter"
                   ,ifelse(type == objTypes[2]
                           ,"Grease & Gum"
                           ,ifelse(type == objTypes[3]
                                   ,"Graffitti"
                                   ,ifelse(type == objTypes[4]
                                           ,"Needles"
                                           ,ifelse(type == objTypes[5]
                                                   ,"Glass"
                                                   ,ifelse(type == objTypes[6]
                                                           ,"Poop & Urine"
                                                           ,"Other"
                                                   )
                                           )
                                   )
                           )
                   )
    )
  ) %>% 
  subset(lat < 37.785) %>% 
  write.csv(FOUT, row.names = FALSE)