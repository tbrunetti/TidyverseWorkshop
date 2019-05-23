library(tidyverse)
library(dplyr)
library(magrittr)
library(broom)

#library(magrittr) introduces the pipe operator %>% pipes into first argument of a function call
#tidyr is good at cleaning data
#if you want to for loop the variable cast/wrap using sym() and it will actually treat it like an object and not a string in tidyverse libraries


data("airquality")
airquality %>% summary()
#airquality is noun and summary is verb, so the output of airquality is passed to the first argument of summary"

# tidyr
#------
# examples in of dropping NAs and getting summary
airquality %>% tidyr::drop_na() %>% summary()

# examples of replacing NAs with 0 of using piping
airquality %>% tidyr::replace_na(list(Ozone =0)) %>% summary()


#tibbles
#-------
# tibbles are basically dataframes that have a refined print method that shows just first 10 rows; also gives you all column types!
aqt <- as_tibble(airquality)
#tibbles is great for subsetting--better error and warning messages than regular dataframes; see example error below (yah is not a column in apt)
aqt$yah
#subsetting in tibbles
aqt$Wind


# data wrangling can be done with dplyr
#----------------------------------------
# verbs: mutate() select() and pull() filter() arrange() summarise() group_by()
# filter() -- select for all rows that are in June
aqt %>% filter(Month == 6)
# select() and pull() select returns a tibble and pull returns a vector of the same thing
aqt %>% filter(Month == 6) %>% select(Ozone)
aqt %>% filter(Month == 6) %>% pull(Ozone)
aqt %>% filter(Month == 6) %>% select(Ozone, Wind)
# another example of pipe and pull
aqt %>% pull(Ozone) %>% summary()
# for day one, subset the ozone column and summarize it
aqt %>% filter(Day == 1) %>% pull(Ozone) %>% summary()

#new pipe type: %<>% is more memory efficient than actually writing to a new dataframe
#aqt <- aqt %>% somthing is equal to aqt %<>% something
#mutate() creates a new variable(column) -- new variable is called TempC; if using a column that already exists, it replaces it
aqt %<>% mutate(TempC = (Temp -32) * 5/9)
aqt %<>% mutate(Testing = Ozone/Wind)

#arrange() ordering a tibble or dataframe by a column
aqt %>% drop_na() %>% arrange(Ozone)

# summarise() -- returns summary as a tibble
aqt %>% summarise(mean_temp = mean(Temp))

# group_by() -- summarize mean temp for each group example
aqt %>% group_by(Month) %>% summarise(mean_temp = mean(Temp))


#ggplot2
#--------
#geom_point()
aqt %>% ggplot(aes(x=Wind, y=Ozone)) + geom_point()
aqt %>% ggplot(aes(x=Wind, y=Ozone)) + geom_point() + stat_smooth(method = 'lm')
aqt %>% ggplot(aes(x=Wind, y=Ozone)) + geom_point() + stat_smooth(method = 'lm', se = FALSE)
#geom_histogram()
aqt %>% ggplot(aes(x=Temp)) + geom_histogram(bins=10)
aqt %>% ggplot(aes(x=Temp, fill = factor(Month))) + geom_histogram(bins=10)
#geom_boxplot()
aqt %>% ggplot(aes(x=factor(Month), y=Ozone)) + geom_boxplot()
# other cool graphs and layering graphs
aqt %>% ggplot(aes(x=factor(Month), y=Ozone)) + geom_point()
aqt %>% ggplot(aes(x=factor(Month), y=Ozone)) + geom_boxplot() + geom_point() 
aqt %>% ggplot(aes(x=factor(Day), y=Ozone)) + geom_boxplot() + geom_point() 

# purrr is a functional programming toolkit by trying to eliminate for loops
# map()
l < list('one' = 1, 'two' =2, 'three' =3)
lroot1 < l %>% map(sqrt) # replaces the full for loop below
lroot <- list()
for (i in names(l)){
  lroot[[i]] <- sqrt(lroot[[i]])
}
#pluck() -- takes an item out of a lits
lroot %>% pluck(2) # number refers to position or if a tibble column in a data set

# broom -- glance(yourModel) to get rSq, pval, sigma, etc...
#       -- augment(yourModel) adds all parameters of the fit for each row to your tibble