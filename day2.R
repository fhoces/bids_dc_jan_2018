# Loading required libraries
list.of.packages <- c("foreign", "stargazer", "sandwich", "haven", "tidyverse", "lfe")

# Chicking if library installed, installed if not. 
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos= "http://cran.cnr.berkeley.edu/") 

# Calling libraries 
lapply(list.of.packages, require, character.only = TRUE)


download.file("https://ndownloader.figshare.com/files/2292169",
              "data/portal_data_joined.csv")


surveys <- read_csv("data/portal_data_joined.csv")
