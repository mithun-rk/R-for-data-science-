install.packages(tidyverse)
library(tidyverse)
ggplot2::ggplot()# tell you explicitly that you are using ggplot
# function from ggplot2 package. 

install.packages(c("nycflights13","gapminder","Lahman"))
# we will use data from the above packages

# Let’s use our first graph to answer a question: do cars with 
# big engines use more fuel than cars with small engines? 
# What does the relationship between engine size and fuel efficiency 
# look like? Is it positive? Negative? Linear? Nonlinear? 
mpg
head(mpg)
dim(mpg)
# Plotting relationship.
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy))
# The plot shows a negative relationship between engine size (displ) 
# and fuel efficiency (hwy). In other words, cars with big engines use 
# more fuel. 
# Does this confirm or refute your hypothesis about 
# fuel efficiency and engine size?

# Excercises
# 1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg)
# an empty chart gets populated as we have not specified more layers. 
# 2. How many rows are in mtcars? How many columns?
mtcars
dim(mtcars)
# there are 32 rows and 11 column in the mtcars data set. 
# 3. What does the drv variable describe? 
# Read the help for ?mpg to find out. 
?mpg
# f stands for front wheel drive & r stands for rear wheel drive.
# 4. Make a scatterplot of hwy versus cyl.
ggplot(data = mpg)+ geom_point(mapping = aes(x = hwy,y = cyl))
# What happens if you make a scatterplot of class versus drv? 
# Why is the plot not useful?
ggplot(data = mpg) + geom_point(mapping = aes(x = class, y = drv))
# these are 2 categorical variables, a cross tab would provide 
# intellingent insignts than a scatter. 

# Asthetics
# You can add a third variable, like class, to a two-dimensional scatterplot 
# by mapping it to an aesthetic. 
# Color as asthetics
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# Size as asthetics
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, size = class)) 

# Top
# alpha portrays things in various levels of transparancy. 
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
# Bottom 
# Shapes - there are only six discrete shapes hence it drops 7th
# there are 25 builtin shapes, only six are discrete rest are variants. 
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
# Color
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# Exercise:
# 1. What’s gone wrong with this code? 
# Why are the points not blue? 
ggplot(data = mpg) +  geom_point( mapping = aes(x = displ, y = hwy, color = "blue"))
# color is being defined as part of aes with x & y, and not seprately.
# hence the color picked was some kind of mix. 

# 2. Which variables in mpg are categorical? Which variables are continuous? 
# How can you see this information when you run mpg?
mpg<- data.frame(mpg, stringsAsFactors = TRUE)
str(mpg)
?mpg
# Categorical varialbes include 1) manufacturer model 2) Year
# 3) typd of transmission 4) drv 5) fuel type 6) type of car.

# 3. Map a continuous variable to color, size, and shape. 
# How do these aesthetics behave differently for categorical versus continuous variables?
# Mapping continous variable hwy
range(mpg$hwy)
ggplot(data = mpg)+geom_point(mapping = aes(x = displ, y = mpg$model), color = "red")
ggplot(data = mpg)+geom_point(mapping = aes(x = displ, y = mpg$model), shape= 20)
ggplot(data = mpg)+geom_point(mapping = aes(x = displ , y = mpg$year), size = 5)
# its not a scatter where you can map linear relationship.

# Mapping for categorical variable
ggplot(data = mpg)+ geom_point(mapping = aes(x = mpg$manufacturer, y = 0), color = "green")
# we dont have y, we forced the y to 0 its not a great site. 

# 4. What happens if you map the same variable to multiple 
# aesthetics?
ggplot(data = mpg)+ geom_point(mapping = aes(x = mpg$cyl, y = mpg$hwy), 
                      color = "red", shape = 20)
# it throws errors. 

# 5. what does the stroke aesthetic do? what shapes does it work
# with?
?geom_point
ggplot(data = mpg)+ geom_point(mapping = aes(x = mpg$cyl, y = mpg$hwy), 
                               color = "red", shape = 20, stroke = 5)
# stroke argument gives it stroke to the point, looks like star.
# they work well with circular shapes, not with square. 

# 6. What happens if you map an aesthetic to something other than a 
# variable name, like aes(color = displ < 5)?
ggplot(data = mpg)+ geom_point(mapping = aes(x = mpg$cyl, y = mpg$hwy), 
                               color = mpg$displ < 5)
# it throws an error. 

# Mistakes in code
ggplot(data = mpg)
+ geom_point(mapping = aes(x = mpg$cyl, y = mpg$hwy), 
                             color = "red", shape = 20, stroke = 5)
# this kind of code where + comes in second line wont work. 


## FACET: Meaning one side of something many side.
# especially of cut gem. 
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) + facet_wrap(~ class, nrow = 2) 
# here we have cut of facet by defining facet_wrap as class

# To facet your plot by a combination of two variable use 
# facet_grid instead of facet_wrap
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) +  facet_grid(drv ~ cyl)

# 
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) +  facet_grid(. ~ cyl)

## Exercises 
#  1.What happens if you facet on a continuous variable? 
## Faceting means cutting one variable by other however if i 
# chose to facet of cut with a cutinous variable it wont work
# as i dont have defined bins or characteristics cut based on/ 

# 2. what do the empty cells in the plot with facet_grid(drv~cyl)
# mean? How do you relate to this plot?
ggplot(data = mpg) +  geom_point(mapping = aes(x = drv, y = cyl)) 
# facet _grid tries to establish a linear relatonship between 
# drv and cyl while the actual x & y scales are different.
# it shows relationship in two levels.

# 3. what does the following code make? what does .do?
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) +  facet_grid(drv ~ .)

ggplot(data = mpg) +  geom_point(mapping = aes(x = displ,
    y = hwy)) +  facet_grid(. ~ drv)
# that . defines the 3 rd axix. If we have . followed by class argument
# then argument takes the w axis opposite to y. else z opposite to x

#4. take the first plot in this secton 
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, 
  y = hwy)) +   facet_wrap(~ class, nrow = 2) 
# what are the advantages to using istead of color? 
# what are the disadvantages? 
# how might the balance change if you have a larger data set?

# with color the advantage is we can see the relationship between
# hwy and displ first and then see some sub patterns based on the
# class of the car. However when we facet by class we can make out
# the pattern or relationship of hwy & displ for each class but
# overalll pattern is little difficult to make out. 
# if i have a bigger data set i will first use the color visual
# and subsequently facet it. 

# QUICK WRITE UP ON FACET:
# another particularly useful for categorical variables is to split 
# your plot into facet, sub plots that each display one subset of the data.
# to facet your plot with single variable, use facet_wrap()
# to facet your plot on the combination of two variable use facet_grid()

#5. In facet_wrap() what does nrow do? what does ncol do?
# what other option control the layout of the individual panels?
# why doesnt facet_grid() have nrow and ncol variables?
## there is nrows and ncol to specify how many visuals should
# get populated. Wth facet_grid we already have the no.of visual defined
# by its w & Z axis.

#6. when using facet_grid() you should usually put the variable
# wiht more unique levels in the colums. why?
# Cause it will help give better insights about the variable. 


# Geometric objects:
# A geom is a geometric object that plot uses to represent data.
# bar chart use bar geom, line chart uses line geom, boxplot
# uses boxplot geom, scatter plot use point goem. 

# only points 
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy))
# now a smoothed line of the points 
ggplot(data = mpg) +  geom_smooth(mapping = aes(x = displ, y = hwy))
# different line type for each levels of the varialbe. 
ggplot(data = mpg) +  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# makeing the smooth line
ggplot(data = mpg) +  geom_smooth(mapping = aes(x = displ, y = hwy))
# group the line by drv
ggplot(data = mpg) +  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
# group the line by drv using different color.
ggplot(data = mpg) +  geom_smooth( mapping = aes(x = displ, y = hwy, color = drv),show.legend = FALSE  )

# To show the point as well as the smooth line
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
# A more efficient and concise code where data & mappings are defined
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +  geom_smooth()

# After defining the data and global mapping we can also define
# local geom mappings and its aes. it will use these mappings 
# to extend of overwrite the global mappings for that layer only.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
geom_point(mapping = aes(color = class)) +  geom_smooth()

# here we select the data, but we do not want to smooth all the
# points there but only line made of class subcompact. geom_smooth
# with its specific mappings gives the line of subcompact cars.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
geom_point(mapping = aes(color = class)) +
geom_smooth(    data = filter(mpg, class == "subcompact"),
se = FALSE  )

## Excercise
#1. what geom would you use to draw a line chart? a boxplot? a
# histogram and an area chart?
## geom_line
## geom_boxplot
## geom_histogram
## geom_area

#2. Run this code in your head and predict what the output wil
# look like? then run the code to check your predictions.
# Am good with this now
ggplot(  data = mpg,  mapping = aes(x = displ, y = hwy, color = drv) ) +
geom_point() +  geom_smooth(se = TRUE) 

#3. what does show.legend = false do? what happens if you remove it
# why do you think i used it earlier in the chapter.
ggplot(data = mpg) +  
  geom_smooth(    mapping = aes(x = displ, y = hwy, color = drv) )
# by default it will show legends unless you state explicitly otherwise.

#4. what does the se argument in geom_smooth() do?
#  se true display confidence interval around the smooth. 
?geom_smooth()

# 5. will thes two graph look different?
# nope
ggplot() +  geom_point(    data = mpg,    mapping = aes(x = displ, y = hwy)  ) +  geom_smooth(    data = mpg,    mapping = aes(x = displ, y = hwy)  ) 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +  geom_point() +  geom_smooth()

# 6 Code for the visual shown in the books

ggplot(data = mpg, mapping = aes(x =displ, y = hwy)) +  geom_point(size = 5)+ geom_smooth( se = FALSE)

ggplot(data = mpg, mapping = aes(x =displ, y = hwy)) +  geom_point(size = 2)+ geom_smooth(mapping = aes(x =displ, y = hwy, group = drv, se = FALSE))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv),size = 4) +  geom_smooth(mapping = aes(group=drv), se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv),size = 4) +  geom_smooth(se = FALSE)

# STATISTICAL TRANSFORMATION
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut)) # by default geom_bar user stat_count

ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut)) # same result if we use stat_count

demo <- tribble(  ~a,      ~b,
                  "bar_1", 20,  "bar_2", 30,  "bar_3", 40 )
demo
# here am changeing stat from default to identity to get the raw score from data.
ggplot(data = demo) +
  geom_bar( mapping = aes(x = a, y = b), stat = "identity")

# we want in proportions
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group= 0))

# if we want to display the summary stats. 
ggplot(data = diamonds) +
  stat_summary(mapping = aes(x = cut, y = depth),
  fun.ymin = min,
  fun.ymax = max,
  fun.y = median  )

## Excercise
#1. what is the default geom associated with stat_summary()?
# how would you re-write the previous plot to use the geom funtion
# instead of stat_function
?stat_summary
# defualt geom is histogram
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = cut, y = depth),
               fun.ymin = min,
               fun.ymax = max,
               fun.y = median  )

# 2. What does geom_col() do? how is it different from geom_bar()
?geom_col
#here are two types of bar charts: geom_bar makes the height 
# of the bar proportional to the number of cases in each group 
#(or if the weight aethetic is supplied, the sum of the weights). 
#If you want the heights of the bars to represent values in the 
#data, use geom_col instead. geom_bar uses stat_count by default: 
#it counts the number of cases at each x position. geom_col uses 
#stat_identity: it leaves the data as is.

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(data = diamonds) +
  geom_bar(    mapping = aes(x = cut, fill = color, y = ..prop..) )
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., 
                         group = 1)  )




