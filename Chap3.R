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
# if there is any missing value in the input, the output will be 
# missing value. However all aggregate functions have an na.rm argument.

# here NA.s were on account of cancelled flights one way to deal with this is
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay),!is.na(arr_delay))
not_cancelled %>% group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay))
# ! indicates a logical nagation.

## Counts
delays <- not_cancelled %>%
  group_by(tailnum) %>% summarise(delay=mean(arr_delay))

ggplot(data = delays, mapping = aes(x = delay))+ geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>%
  group_by(tailnum) %>% summarise(delay=mean(arr_delay, na.rm = TRUE),
                                  n = n())
ggplot(data= delays,mapping = aes(x = n, y= delay)) +
  geom_point(alpha = 1/10)

# Removing outliers: i only keeping flight that have been delayed more that 25 times
delays %>% filter(n >25) %>% ggplot(mapping = aes(x = n, y = delay))+ 
  geom_point(alpha = 1/10)

# Similar operation in another data.
batting <- as.tibble(Lahman::Batting)
?Batting
batters<- batting%>% group_by(playerID)%>% 
  summarise(ba = sum(H,na.rm = TRUE)/sum(AB, na.rm = TRUE),
            ab = sum(AB, na.rm= TRUE))
batters %>% filter(ab>100)%>%
  ggplot(mapping=aes(x = ab,y = ba))+ geom_point()+geom_smooth(se=FALSE)


## Usefull summary functon
# measures of central location mean(x), median(x)
not_cancelled %>% group_by(year,month,day)%>% summarise(
  avg_delay1 = mean(arr_delay),avg_delay2=mean(arr_delay[arr_delay>0])
)

# Measures of spread
# sc(),IQR(),mad()
not_cancelled %>% group_by(dest) %>%
  summarise(distance_sd=sd(distance))%>% arrange(desc(distance_sd))

# measure of rank
# min(), max(), quintile(x,0.25)
not_cancelled %>% group_by(year,month,day)%>%
  summarise(first = min(dep_time),
            last = max(dep_time))

# measure of position
# first(x), nth(x,2), last(x)

not_cancelled %>% group_by(year,month,day) %>%
  summarise(first_dep = first(dep_time),
            last_dep = last(dep_time))

### Counts
# n() takes no argument and returns the size of current group.
# to count the number of non missing value use sum(! is.na(x))
# to count the number of distict (unique) values use n_distinct()
not_cancelled %>% group_by(dest) %>%
  summarise(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

# simple count
not_cancelled %>% count(dest)
# you can provide weight to a variable and count
not_cancelled %>% count(tailnum, wt= distance)
# how many flight left before 5 am 
not_cancelled %>% group_by(year,month,day) %>%
  summarise(n_early = sum(dep_time < 500))
# what is the propotion of flights delayed by more than an hour?
not_cancelled %>% group_by(year,month,day) %>%
  summarise(hour_perc = mean(arr_delay>60))

## Grouping by multiple variables 
# count of flights on a daily basis
daily <- group_by(flights,year, month, day)
(per_day <- summarise(daily,flights = n()))
# count on a monthly basis
(per_month <- summarise(per_day,flights = sum(flights)))
# count per year basis
(per_year<- summarise(per_month,flights = sum(flights)))

# Ungrouping 
daily %>% ungroup() %>% summarise(flights = n())

# Grouped Muttates and filter
# find the worst member of each group
flights_sml %>% group_by(year, month, day) %>%
  filter(rank(desc(arr_delay))<10)
# find all bigger than a threshold 
popular_dest <- flights %>% group_by(dest) %>%
  filter(n()>365)
popular_dest
# standardise to compute per 
popular_dest %>% filter(arr_delay >0) %>%
  mutate(prop_delay = arr_delay/sum(arr_delay)) %>%
  select(year:day, dest,arr_delay,prop_delay)
