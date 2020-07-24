# CREATED BY: Alexander Kahanek

####### ALL LIBRARIES USED ###########
options(stringsAsFactors = FALSE)
library(dplyr)
library(lubridate)

####### HYPERPARAMETERS ##############
FIN = 'data/SoMaWestRShiny.csv'
FOUT = "clean_rubbish.csv"

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
  write.csv(FOUT, row.names = FALSE)