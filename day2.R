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


surveys %>% 
  group_by(plot_type, taxa) %>% 
  tally %>%  
  left_join(
    surveys %>% 
      group_by(plot_type) %>% 
      summarise(tot = n())) %>%
      mutate(taxa_perc = (n/tot)*100)


# Challenges from here: 
# #http://www.datacarpentry.org/R-ecology-lesson/03-dplyr.html#reshaping_with_gather_and_spread

# Challenge 1: spread
s_data <- surveys %>%
  group_by(year, plot_id) %>% 
  summarise(var1 = n_distinct(genus)) %>% 
    spread(key = year, value = var1)

# Challenge 2: gather back


# Challenge 3: gather multiple cols
g_data <- surveys %>%
  gather(key = measurement, 
         value = lw, 
         hindfoot_length:weight) 

# Challenge 4: 
hlm_sum <- g_data %>% group_by(year, plot_type, measurement) %>% 
            summarise(mlw = mean(lw, na.rm = T)) %>% 
                spread(key = measurement, value = mlw)
        


# Exporting data 
surveys_complete <- surveys %>%
  filter(!is.na(weight),           # remove missing weight
         !is.na(hindfoot_length),  # remove missing hindfoot_length
         !is.na(sex))  


## Extract the most common species_id
species_counts <- surveys_complete %>%
  group_by(species_id) %>%
  tally() %>%
  filter(n >= 50)

## Only keep the most common species
surveys_complete <- surveys_complete %>%
  filter(species_id %in% species_counts$species_id)

## export data
write_csv(surveys_complete, path = "data_output/surveys_complete.csv")


surveys_complete <- read_csv("data_output/surveys_complete.csv")

ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
  geom_point()
