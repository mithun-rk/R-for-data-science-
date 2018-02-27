library(tidyverse)
# cut is categorical
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
diamonds %>% count(cut)
View(diamonds)

# carat is contious 
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

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

ggplot(diamonds) +  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds) +  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +  coord_cartesian(ylim = c(0, 50))

unusual <- diamonds %>% filter(y <3 | y>20)%>% arrange(y)
unusual
