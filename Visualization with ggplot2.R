library(tidyverse)
install.packages(c("nycflights13","gapminder","Lahman"))
# we will use data from the above packages

# Let’s use our first graph to answer a question: do cars with 
# big engines use more fuel than cars with small engines? 
# What does the relationship between engine size and fuel efficiency 
# look like? Is it positive? Negative? Linear? Nonlinear? 
mpg
head(mpg)
# Plotting relationship.
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy))
# The plot shows a negative relationship between engine size (displ) 
# and fuel efficiency (hwy). In other words, cars with big engines use 
# more fuel. Does this confirm or refute your hypothesis about 
# fuel efficiency and engine size?

# Excercises
# 1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg)
# an empty chart gets populated as we have not specified more layers. 
# 2. How many rows are in mtcars? How many columns?
mtcars
dim(mtcars)
# there are 32 rows and 11 column in the mtcars data set. 