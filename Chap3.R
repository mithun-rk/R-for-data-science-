# Chapter 3 
# Data trasnsformation with dplyr

library(nycflights13)
library(tidyverse)
# tibbles are data frames but slightly tweeked to work better in tidyverse
# Types of variables
# 1. int <- integer
# 2. dbl <- double or real numbers
# 3. chr <- character
# 4. dttm <- data time (date + time)
# 5. lgl <-  logical (true or false)
# 6. fctr <- factors (categorical variables with fixed possible values)
# 7. date <- date  

## Five key dyplr functions that allows vast data manipulation
# filter() <- pick observations by their value
# arrange() <-  reorder the rows
# sellect() <-  pick varibales by their names.
# mutate() <-  create new variables wiht functions of existing variable. 
# summarize() <- collapse many values into single summary
# these can be used in conjuction with group_by()

## how it works
#1. the first argument is a data frame.
#2. the subsequent argument describes what to do wiht the data frame
# using the variable names
#3. the result is a new data frame. 

## Filter
filter(flights, month==1, day == 1)# data followed by filter condition
# if i want to save the result then assign
jan1 <- filter(flights,month==1,day==1)
# if i want to asssign and print in console 
(dec25 <- filter(flights,month==12,day==25))# put parenthesis around everything

# the following code finds all the flights that departed in 
# november or december
filter(flights, month ==11| month==12)
# filter(flights, month = 11|12) wont work
# another way is to use the pipe function
nov_dec <- filter(flights, month %in% c(11,12))# used %in%

### Excercises pending

### Arrange rows with arrange()
arrange(flights,year, month,day) #uses set of column names
# use desc() to column in descending order
arrange(flights,desc(arr_delay))

## Excercise pending

# Select columns with select()
select(flights,year,month,day) # specific columns
select(flights, year:day) # between year and day

# select all columns except between year and day (inclusive)
select(flights,-(year:day)) # dropped some variables
# there are various helper functions of select
# start_with("abc")
# end_with("abc")
# contains("abc")
# matches() # not sure about this 
# num_range("x", 1:3) matches x1, x2 and x3.


# Use rename() which is a variant of select to rename variables
rename(flights, tail_num = tailnum)
head(flights)
View(flights)

# Another variant of select is to use it with everything()
select(flights,time_hour,air_time,everything()) # basically moves the 
# 2 variables of interest to the start of df.

#### Excercise pending

## Add new variable with mutate()
# mutate adds new columns at the end of your dataset
flights_sml <- select(flights,  year:day,  ends_with("delay"),
                      distance,  air_time ) 
head(flights_sml)

# using mutate to create 2 new variable
(mutate(flights_sml,  gain = arr_delay - dep_delay,
       speed = distance / air_time * 60)) 
       
(mutate(flights_sml,  gain = arr_delay - dep_delay,
       hours = air_time / 60,  gain_per_hour = gain / hours )) 

# if you only want to keeo the new variables use transmute()
(transmute(flights,  gain = arr_delay - dep_delay,
  hours = air_time / 60,  gain_per_hour = gain / hours )) 

# Modular arthmetic
# %/% will keep only the integer part, the remainder post division is ignored
transmute(flights,dep_time,hour=dep_time %/% 100,
          minute = dep_time %/% 100)
# Cumulative rolling aggregates 
# cumsum()
# cumprod()
# cummin()
# cummax()
# cummean()

# Ranking functions 
y<- c(1,2,2,NA,3,4)
min_rank(y)
min_rank(desc(y))

row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

## Grouped summaries with summarize()
summarize(flights, delay = mean(dep_delay, na.rm = TRUE)) # not much of use 
summary(flights$dep_delay)

## a better usage
by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE)) 
## group_by() and summarize() will be used very commonly. 

## Combining multiple operations with pipe
by_dest <- group_by(flights,dest)
# here we define a variable by its dest
delay<- summarize(by_dest,count = n(),
                  dist = mean(distance, na.rm = TRUE),
                  delay = mean(arr_delay, na.rm = TRUE))
# then we define a summary count of dest with avg of dist & delay
delay <- filter(delay, count > 20, dest != "HNL")
# now we filtert by count greater than 20 and dest HNL

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

## %>% called the pipe and can come handy
delays <- flights %>% group_by(dest) %>% summarise(count=n(),
          dist = mean(distance,na.rm = TRUE),
          delay = mean(arr_delay, na.rm = TRUE))%>%
  filter(count > 20, dest != "HNL")
## Read %>% as then 
## group by then summarise then filter

## Missing values 








