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















