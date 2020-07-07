# testing reticulate
library(dplyr) # for main data manipulations
library(reticulate)
source_python('bin_geo.py')

print(head(raw))

usrdata <- raw

usrmat <- script_bins(usrdata$lat, usrdata$long, 20, 30) %>% 
  as.matrix()

# ml <- max(lengths(usrmat))
# usrmat <- do.call(rbind, lapply(usrmat, function(x) `length<-`(unlist(x), ml)))

usrmat <- do.call("rbind",usrmat)

print(usrmat)