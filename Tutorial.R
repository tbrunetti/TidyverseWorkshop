#Load libraries
library(tidyverse)
library(magrittr)

#Load the data
data()
data("airquality")

#Inspect the data
head(airquality, 5)
nrow(airquality)
dim(airquality)
class(airquality)

#Summarize the data
airquality %>% summary()
airquality %>% drop_na() %>% summary()

#Exercise 1: replace_na()
airquality %>% replace_na(list(Ozone=0)) %>% summary()

#Convert to tibble
aqt <- as_tibble(airquality)
aqt
airquality$yea
aqt$yea

#dplyr::filter to filter data and dplyr::select to select variables
aqt %>% filter(Month == 6)
aqt %>% filter(Month == 6) %>% select(Ozone)
aqt %>% filter(Month == 6) %>% pull(Ozone)

#Exercise 2: Pull down a variable and look at the summary
aqt %>%
  pull(Ozone) %>%
  summary()

aqt %>% filter(Day == 1) %>%
  pull(Ozone) %>%
  summary()

#dplyr::mutate to create new variables
aqt %<>% mutate(TempC = (Temp - 32) * 5/9)
aqt

#Exercise 3: Create a new variable
aqt %<>% mutate(OzoneByWind = Ozone/Wind)
aqt

#dplyr::arrange to order a tibble by value
aqt %>% drop_na() %>% arrange(Ozone)
aqt %>% drop_na() %>% arrange(Ozone) %>% tail()

#Summarize data by groups
aqt %>% summarise(mean_temp = mean(Temp))
aqt %>%
  group_by(Month) %>%
  summarise(mean_temp = mean(Temp))

#Exercise 4: Get median Solar radiation (Solar.R) grouped by Month.
aqt %>% group_by(Month) %>%
  summarise(median_rad = median(Solar.R, na.rm = T))

#ggplot
aqt %>% ggplot(aes(x=Wind, y=Ozone)) +
  geom_point()
aqt %>% ggplot(aes(x=Wind, y=Ozone)) +
  geom_point() +
  stat_smooth(method = 'lm', se = F)

aqt %>% ggplot(aes(x=Temp)) +
  geom_histogram(bins = 10)
aqt %>% ggplot(aes(x=Temp, fill = factor(Month))) +
  geom_histogram(bins = 10)
aqt %>% ggplot(aes(x=factor(Month), y=Ozone)) +
  geom_boxplot()

#Exercise 5: How do Ozone distributions vary by day?
aqt %>% ggplot(aes(x=factor(Day), y=Ozone)) +
  geom_boxplot()

#Bonus: purrr
l <- list('one' = 1, 'two' = 2, 'three' = 3)
lroot <- list()
for(i in names(l)) {
  lroot[[i]] <- sqrt(l[[i]])
}
lroot
lroot1 <- l %>% map(sqrt)
lroot1
lroot[[2]]
lroot %>% pluck(2)

aqt %>% filter(Month == 9) %>%
  mutate(Feeling = ifelse(Temp < 70, 'Cool', 'Warm'))
aqt %>% filter(Month == 9) %>%
  mutate(Feeling = ifelse(Temp < 70, 'Cool', 'Warm')) %>%
  pluck(8)

#Broom
library(broom)
fit <- lm(Ozone ~ Wind, aqt)
fit %>% summary()
tidy(fit)
glance(fit)
augment(fit)

#bonus: new data
data("iris")
iris %<>% as_tibble()
iris
iris %>% pull(Species) %>% unique()
iris %>% group_by(Species) %>% summarise(mean_sepalL <- mean(Sepal.Length), mean_sepalW <- mean(Sepal.Width))
iris %>% ggplot(aes(x=Species, y=Sepal.Length)) + geom_boxplot()
iris %>% ggplot(aes(x=Sepal.Length, y=Sepal.Width)) + geom_point()
iris %>% ggplot(aes(x=Sepal.Length, y=Sepal.Width, color = Species)) + geom_point()
iris %>% ggplot(aes(x=Sepal.Length, y=Sepal.Width, color = Species)) + geom_point() + stat_smooth(method='lm', se = F)

