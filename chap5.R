# Two type of question will always be useful for making discoveries
# within your data
# 1. what type of variation occurs within my variables?
# 2. what type of covariation occurs with my variables?

# Visualizing Distribution
# Visualizing variable will depend on whether its 
# a. Categorical or b. Continous 
# R saves categorical variables as factors or character vector. 
library(tidyverse)
# cut is categorical - hence bar 
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
diamonds %>% count(cut)
View(diamonds)

# carat is continous - hence histogram
# key here is bin width using cut_width measured in units of x
# explore variety of bin widths.
ggplot(data = diamonds) + geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
diamonds%>% count(cut_width(carat,0.5))

# Some more data manipulations
smaller <- diamonds%>% filter(carat<3)
ggplot(data=smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)
# if you need to show multiple feature histogram use geom_freqpoly()
# it uses lines instead of bars 
ggplot(data = smaller, mapping = aes(x = carat, color = cut))+
  geom_freqpoly(binwidth = 0.1)

# Typical values 
# General dicovery question to look for 
#1. which values are most common? Why?
# 2. Which values are rare? Does that match your expectations?
#3. Can you see unusal patterns? What might explain them?
ggplot(data = smaller,mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01)

# More questions
#1. How are observations within each cluster similar to each other?
#2. How are observations in different cluster different from each other?
#3. how can you explain or describe the cluster.
#4. why might the appearence of cluster be misleading.


# Lets explore the faitful geyser in yellowstone dataset
ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)
# You can see two clear cluster of eruptions. 

# Unusual values
# outlier are the unusual values  
ggplot(diamonds) +  geom_histogram(mapping = aes(x = y),
                                   binwidth = 0.5)
# sometime since there is a lot of data the outlier are not visible.
# we can use coord_cartesian to zoom in
ggplot(diamonds) +  geom_histogram(mapping = aes(x = y),
      binwidth = 0.5) +  coord_cartesian(ylim = c(0, 50))
# now we see outliers at 0, ~30,~60
# here we were zooming in at ylim we can do the same for xlim as well.

# lets us remove these unusual or outlier values 
unusual <- diamonds %>% filter(y <3 | y>20)%>% arrange(y)
unusual
