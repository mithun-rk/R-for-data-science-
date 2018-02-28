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

# Not at all recommended, however you can drop the entire row with
# strange values
diamonds2 <- diamonds %>% filter(between(y,3,20))
# unusal values should not be silently removed, instead replaced with NA
diamonds2<- diamonds %>% mutate(y = ifelse(y <3|y>20,NA,y))
# ifelse has 3 arguments, the first argument test should be a logical 
# vector. The result will contain the values of second argument
# , yes wehn the test is true, and the values of third argument 
# no when it is false.

# if there are na's ggplot will plot with an error message. 
ggplot(data = diamonds2, mapping = aes(x =x, y=y))+ geom_point()
# to supress the warning 
ggplot(data = diamonds2, mapping = aes(x =x, y=y))+ 
  geom_point(na.rm = TRUE)

# 
nycflights13::flights %>% mutate(
  cancelled = is.na(dep_time),
  sched_hour = sched_dep_time %/% 100,
  sched_min = sched_dep_time %% 100,
  sched_dep_time = sched_hour+sched_min/60
) %>%
ggplot(mapping = aes(sched_dep_time))+ geom_freqpoly(
  mapping = aes(color = cancelled), binwidth = 1/4
)

# Covariation 
# A categorical and a continous variable.
ggplot(data = diamonds,mapping = aes(x = price))+
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
# it is difficult to see the difference in the distribution
# because overall counts differ so much. 

ggplot(diamonds) + geom_bar(mapping = aes(x =cut))
# to make comparision easier,lets use density instead on counts
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
# seems fair diamonds have the highest average price, its kind of 
# surprising lets check with a boxplot
ggplot(data = diamonds, mapping = aes(x = cut, y = price))+
  geom_boxplot()
# in the diamond data cut has an implicit order good is better than fair
# you may need to reorder the categories if no such implicit order is present
ggplot(data = mpg, mapping = aes(x = class, y= hwy))+
  geom_boxplot()
# lets reorder by median
ggplot(data = mpg)+
  geom_boxplot(mapping = aes(x = reorder(class,hwy,FUN = median),
                             y=hwy))

# if we have long variable names its better to flip
ggplot(data = mpg)+
  geom_boxplot(mapping = aes(x = reorder(class,hwy,FUN = median),
                             y=hwy))+ coord_flip()

## Two Categorical variables
ggplot(data = diamonds)+ geom_count(mapping = aes(x = cut,
                                                  y= color))
# the size of each circle in the plot displays how many observations
# occured for each combination of values. 

# Another approach
diamonds %>% count(cut,color)
# then visualize using geom_tile
diamonds %>% count(color,cut) %>% 
  ggplot(mapping = aes(x = cut, y = color))+
  geom_tile(mapping = aes(fill = n))

## Two continous variable
# the best way is scatter plot with geom_point
ggplot(data = diamonds, mapping = aes(x = carat, y= price))+ 
  geom_point()
# Scatter become less useful as dataset grows.
# this problem can be partly fixed by using alpha aesthetic
ggplot(data = diamonds) + geom_point(mapping = aes(x = carat,
                y= price), alpha = 1/50)

# geom_hist and geom_freqpoly bins the data in one diamension mostly x axis
# now lets bin in 2 diamension
# geom_bin2d() & geom_hex() divide the coordinate plane into
# 2D bins and then use a fill color to display how many points
# fall in each bin
ggplot(data = smaller) + geom_bin2d(mapping = aes(x = carat, y= price))

install.packages("hexbin")
ggplot(data = smaller) + geom_hex(mapping = aes(x = carat, y = price))

# If you want a continous variable to act like categorical
ggplot(data = smaller, mapping = aes(x = carat, y = price))+
  geom_boxplot(mapping = aes(group = cut_width(carat,0.1)))
# one way to make the width of the boxplot proportional to the 
# number of points is varwidth = TRUE

# if we want to display same number of points in each bin
ggplot(data = smaller, mapping = aes(x = carat, y = price))+
  geom_boxplot(mapping = aes(group = cut_number(carat,20)))

## Patterns & Models
# Patterns in data give clues about relationship
# Question to aske
# 1. Could this pattern be due to co-incidence?
#2. How can you describe the relationship implied by the pattern.
# 3. How strong is the relationship implied by the pattern.
# 4. what other variables might effect relationship
# 5. does relationship change for subgroups. 

# Scatter plot shows pattern, longer the wait time higher eruption
ggplot(data = faithful)+ geom_point(mapping = aes(x = eruptions,
                                                  y = waiting))
## Model
# In diamonds data we found a strong relationship between price and carat
# we fit a lm model and use the residual to find the relationship

library(modelr)
mod<- lm(log(price)~log(carat), data = diamonds)
diamonds2<- diamonds%>%add_residuals(mod)%>%
  mutate(resid = exp(resid))
ggplot(data = diamonds2) + geom_point(mapping = aes(x = carat,
                                                y = resid))
# Once we have removed the strong relationship between carat and
# price we can see the correct relationship between cut and price
# relative to size. 

ggplot(data = diamonds2) + geom_boxplot(mapping = aes(x = cut, y = resid))










