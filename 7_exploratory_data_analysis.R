library(tidyverse)
library(nycflights13)

# http://r4ds.had.co.nz/exploratory-data-analysis.html

## chapter is about using visualisation and transformation
## to explore data in a systematic way
## it is called exploratory data analysis
## EDA for short

# EDA is an iterative cycle:
# 1. generate questions about data
# 2. search for answers by visualisisng, transforming and modelig data
# 3. use answers to create new questions or refine (
# wyklarować, udoskonalić) old ones

# EDA is a state of mind, not a set of strict rules
# at the beggining explore every idea

# data cleaning is an application of EDA

# 7.2 Questions

## quotes:
# Sir David Cox - There are no routine statistical questions,
# only questionable statistical routines

# John Tuckey - Far better an approximate answer to the right question,
# which is often vague, than an exact answer to the wrong question,
# which can always be made precise

#############################################################
# the goal during EDA is to develop an understanding of the dataset
# use questions as tools to guide an investigation
############################################################

### EDA is a creative process, so the key to asking quality questions is 
### to generate a large quantity of questions!

# revealing - odkrywczy

## Hadley: each new question that you ask will expose you to a new aspect of 
## your data and increase your chance of making a discovery. You can quickly 
## drill down into the most interesting part of your data - and develop
## a set of thought-provoking questions - if you follow up each new question
## based on what you find.

##############################################################
# there are two types of questions:
  # 1. what type of variation occurs within my variables? 
  # (jaka jest zmienność wewnątrz każdej ze zmiennych)  

  # 2. what type of covariation occurs between my variables?
  # (jaka jest współzmienność pomiędzy zmiennymi)
##############################################################

# terms:

# A VARIABLE is a quantity, quality, or property that you can measure.

# A VALUE is the state of a variable when you measure it. 
# The value of a variable may change from measurement to measurement.

# An OBSERVATION is a set of measurements made under similar conditions 
# (you usually make all of the measurements in an observation at the same time
# and on the same object). An observation will contain several values, each 
# associated with a different variable. 
# I’ll sometimes refer to an observation as a DATA POINT.

# Tabular data is a set of values, each associated with a variable and 
# an observation. Tabular data is tidy if each value is placed in its own
# “cell”, each variable in its own column, and each observation in its own row

# 7.3 Variation

# variation is the tendency of the values of a variable to change
# form measurement to measurement

# best way to understand variation is to visualise the distribution

# 7.3.1 Visualising distributions

## for categorical variables barplot is the best

diamonds %>% ggplot(aes(x = cut)) + geom_bar()

  # count it manually:

diamonds %>% count(cut)

## for continuous variables use histogram

diamonds %>% ggplot() + geom_histogram(aes(x = carat), binwidth = 0.5)

  # manual count in bins
diamonds %>% count(cut_width(x = carat, width = 0.5))

# You can set the width of the intervals in a histogram with the binwidth
# argument, which is measured in the units of the x variable

# so it gives just one bin:
diamonds %>% ggplot() + geom_histogram(aes(x = carat), binwidth = 6) # useless

# you should always explore a variety of binwidths

diamonds %>% filter(carat < 3) %>% 
  ggplot() + geom_histogram(aes(x = carat), binwidth = 0.1)
  
# to overlay multiple histograms on the one plot
# use geom_freqpoly

diamonds %>% filter(carat < 3) %>% 
  ggplot() + 
  geom_freqpoly(aes(x = carat, colour = cut), binwidth = 0.1)

######################################################
# The key to asking good follow-up (uzupełniających) questions will be 
# to rely on your CURIOSITY (What do you want to learn more about?) 
# as well as your SKEPTICISM (How could this be misleading?)
######################################################

# 7.3.2 Typical values - one variable

## questions:
# which values are the most common? why?
# which values are rare? why? Does it match your expectations?
# can you see any unusual pattern? what might explain them?

diamonds %>% filter(carat < 3) %>% 
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

## this plot suggest questions:
# why are there more diamonds at whole carats and common fractions?
# why there are more close to the right sight of peaks then to the left?
# why there are no bigger than three carats?

faithful %>% ggplot(aes(x = eruptions)) + geom_histogram(binwidth = 0.25)

## this plot shows some clusters of similar values
## it suggest that there are "subgroups" in a dataset
## explore it with questions:
# how are observations within each cluster similar to each other?
# how ate the observations in separate clusters different from each other?
# how can the clusters be described or explained?
# why might the apperance of clusters be misleading?

### many of the questions lead to explore relationship between variables

# 7.3.3 Unusual values

# outliers are unusual observations - data points that do not fit the pattern

##############################################################
# Sometimes outliers are data entry errors; 
# other times outliers suggest important new science
##############################################################

# sometimes outliers are hard to see with large datasets

diamonds %>% 
  ggplot(aes(x = y)) +
  geom_histogram(binwidth = 0.5)
# we see only long x axis, because count bars on the high values are too short


diamonds %>% 
  ggplot(aes(x = y)) +
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
# here we zoom the y axis to see small counts
# it allows to see outliers: 0, ~30, ~60

# let's check it

(out_diamonds <- diamonds %>% 
  filter(y == 0 | y > 20) %>% 
  select(price, x, y, z) %>% 
  arrange(y))
# 7 data points has no dimensions x, y, z
# two others seems to be wrong entries - much to large y! 

###########################################################
# good practice is to repeat your analysis with and without outliers.
# if they have only little effect on results
# and we don't know why they occur
# it is reasonable to replace them and move on
# if they have substantial effect on results
# we need to figure out what caused them
# and disclose that they are removed in a write-up
##########################################################

# 7.3.4 excercises

# 1. 

diamonds %>% select(x, y, z) %>% summary()

# apply(diamonds %>% select(x, y, z), 2, shapiro.test) 
# only for < 5000 data points :)

# install.packages("nortest")
library(nortest)

apply(diamonds %>% select(x, y, z), 2, nortest::ad.test) 
# for all vars p is very small, so not a normal distribution...
# ... but check https://stackoverflow.com/questions/7781798/seeing-if-data-is-normally-distributed-in-r/7788452#7788452

apply(diamonds %>% select(x, y, z), 2, qqnorm) 

diamonds %>% ggplot(aes(x = x)) + geom_histogram(binwidth = 0.01)
diamonds %>% ggplot(aes(x = x)) + geom_histogram(binwidth = 0.1)
diamonds %>% 
  filter(x > 9) %>% 
  select(price, x, y, z) %>% 
  arrange(desc(x))

# x dim - width: only 0s are outliers

diamonds %>% ggplot(aes(x = y)) + geom_histogram(binwidth = 0.01)
diamonds %>% ggplot(aes(x = y)) + geom_histogram(binwidth = 0.1)

# y dim - height: 0s and over 30 mm (two points)

diamonds %>% ggplot(aes(x = z)) + geom_histogram(binwidth = 0.01)
diamonds %>% ggplot(aes(x = z)) + 
  geom_histogram(binwidth = 0.1) +
  coord_cartesian(ylim = c(0, 50))

diamonds %>% 
  filter(z > 6) %>% 
  select(price, x, y, z) %>% 
  arrange(desc(z))

# z dim - depth: 0s and 31.8 
# (this exact value occurs also in a y dim, and it's also outlier)

# 2.
diamonds %>% 
  ggplot(aes(x = price)) + 
  geom_histogram(binwidth = 1)

diamonds %>% 
  ggplot(aes(x = price)) + 
  geom_histogram(binwidth = 5) # visible gap ~1500

diamonds %>% 
  ggplot(aes(x = price)) + 
  geom_histogram(binwidth = 10) # same gap

diamonds %>% 
  ggplot(aes(x = price)) + 
  geom_histogram(binwidth = 100) # same gap

diamonds %>% filter(price < 2500) %>% 
  count(cut_width(x = price, width = 100)) %>% 
  as.data.frame()
## (1.45e+03,1.55e+03]  price bin has only 66 entries - it's a gap

# 3.

diamonds %>% 
  filter(between(carat, 0.99, 1)) %>% 
  count(carat)

# 23 entries of 0.99; 1558 for 1 carat
# caused by marketing - people round value up to 1 because 1 seem
# kind of better than 0.99 for customers 

# 4.
diamonds %>% ggplot(aes(x = z)) + geom_histogram(binwidth = 0.01)

diamonds %>% ggplot(aes(x = z)) + geom_histogram(binwidth = 0.01) +
  coord_cartesian(ylim = c(0, 10)) # just zooms the plot

diamonds %>% ggplot(aes(x = z)) + geom_histogram(binwidth = 0.01) +
  ylim(c(0, 10)) # filters values - removes count > 10


diamonds %>% ggplot(aes(x = z)) + geom_histogram() +
  coord_cartesian(ylim = c(0, 10)) # just zooms the plot

diamonds %>% ggplot(aes(x = z)) + geom_histogram() +
  ylim(c(0, 10)) # filters values - removes count > 10

# default binwidth is 30

# 7.4 Missing values

## two main options of dealing with unusual values:
  # A. delete entire rows with such values
  # B. replace such values with missings

## Hadley recomends B.

diamonds_2 <- diamonds %>% 
  mutate(y = ifelse(test = y < 3 | y > 20, yes = NA, no = y))

diamonds$y %>% summary()
diamonds_2$y %>% summary()

############################
# R philosophy is that missing values should never silently go missing
# ggplot2 doesn't include missings on a plot, but does warns
############################

ggplot(diamonds_2) +
  geom_histogram(aes(x = y)) # Warning message:
                            # Removed 9 rows containing non-finite values (stat_bin). 

# other times we want to understand what makes missings
# in flights missings in dep_time indicates cancelled flight

library(nycflights13)

# reminder: modular arithmetic allows to break integers uo into pieces: 
# %/% - integer division
# %% - remainder

flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_dep_hour = sched_dep_time %/% 100,
    sched_dep_min = sched_dep_time %% 100,
    sched_dep_time = sched_dep_hour + sched_dep_min / 60
  ) %>% 
  ggplot(aes(sched_dep_time)) +
  geom_freqpoly(aes(colour = cancelled), binwidth = 0.25)

# 7.4.1

### 1.
## a) what happens with missing values in a histogram?
flights$dep_time %>% summary() # check

flights %>% ggplot(aes(x = dep_time)) + 
  geom_histogram(binwidth = 100, colour = "white")
## warning: removed rows containing non-finite values

## b) what happens with missing values in a barplot?

flights %>% ggplot(aes(x = dep_time)) +
  geom_bar()
## same warning - x treated as continuous variable

flights %>% ggplot(aes(x = dep_time %>% as.factor())) +
  geom_bar() +
  coord_flip()
## no warning - x as factor, NA's as a category on a plot

### 2. What does na.rm = TRUE do in mean() and sum()

v <- c(1:13, NA, 465.7:491.1, NA, NA)
mean(v)
mean(v, na.rm = TRUE)
sum(v)
sum(v, na.rm = TRUE)
## na.rm = TRUE drops missings, so the statistic can be computed

# 7.5 Covariation
# http://r4ds.had.co.nz/exploratory-data-analysis.html#covariation

# covariation describes the behavior between variables

# it is the tendency for the values of variables
# to vary together in a related way

# way we visualise relationship beetwen variables
# depends od vars type

# 7.5.1 A categorical and continuous var

# continuous broken by categorical

ggplot(diamonds, aes(x = price)) +
  geom_freqpoly(aes(colour = cut), binwidth = 500)
# this way may be not that useful
# because we see count, and groups have very different size
# so smaller groups are hard to watch
ggplot(diamonds) + geom_bar(aes(x = cut))

# let's display density instead of conut
# the area under each polygon is standardised to one

ggplot(diamonds, aes(x = price, y = ..density..)) + # the y
  geom_freqpoly(aes(colour = cut), binwidth = 500)
# there's still a lot going on in this plot

ggplot(diamonds, aes(x = cut, y = price)) +
  geom_boxplot(aes(fill = cut))
# whiskers go to farthest non-outlier point
# an outlier is data point that falls more than 1.5 * IQR from each edge of the box
# boxplots are good for compare groups, compact and easy to fit on one plot
# we see counterintuitive finding that better quality diamonds are cheaper

# 'cut' var is an ordered factor

# let's check an unordered one

ggplot(data = mpg, aes(x = class, y = hwy)) +
  geom_boxplot()

# to see pattern easily, we can reorder factor by median

ggplot(mpg, aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  geom_boxplot()

# to read vars names, we can flip plot

ggplot(mpg) +
  geom_boxplot(aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()

# 7.5.1.1 excercises

# 1.
flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_dep_hour = sched_dep_time %/% 100,
    sched_dep_min = sched_dep_time %% 100,
    sched_dep_time = sched_dep_hour + sched_dep_min / 60
  ) %>% 
  ggplot(aes(sched_dep_time, ..density..)) +
  geom_freqpoly(aes(colour = cancelled), binwidth = 0.25, size = 1)

flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_dep_hour = sched_dep_time %/% 100,
    sched_dep_min = sched_dep_time %% 100,
    sched_dep_time = sched_dep_hour + sched_dep_min / 60
  ) %>% 
  ggplot(aes(cancelled, sched_dep_time)) +
  geom_boxplot(aes(colour = cancelled))

# 2.
?diamonds
plot(diamonds$carat, diamonds$price)
boxplot(carat ~ cut, data = diamonds)

(cor_d <- cor(diamonds[, sapply(diamonds, is.numeric)]))
corrplot::corrplot(cor_d)

## help for corrplots: http://www.sthda.com/english/wiki/correlation-matrix-a-quick-start-guide-to-analyze-format-and-visualize-a-correlation-matrix-using-r-software

# price is strongly linked to carat
# the biggest diamonds tend to have "fair" cut

# 3. 
# install.packages("ggstance")
library(ggstance)
# https://cran.r-project.org/web/packages/ggstance/ggstance.pdf

ggplot(data = diamonds, aes(y = cut, x = price)) + 
  ggstance::geom_boxploth()
# factor has to be placed on y axis


# 4. 
# install.packages("lvplot")
library(lvplot)

ggplot(data = diamonds, aes(x = cut, y = price)) + 
  lvplot::geom_lv()

?geom_lv

# 5.
ggplot(data = diamonds, aes(x = cut, y = price)) + 
  geom_violin(aes(fill = cut))

ggplot(data = diamonds, aes(x = price)) +
  geom_histogram() +
  facet_wrap(facets = ~ cut)

ggplot(data = diamonds, aes(x = price, y = ..density..)) +
  geom_histogram() +
  facet_wrap(facets = ~ cut)

ggplot(data = diamonds, aes(x = price, y = ..density..)) +
  geom_freqpoly(aes(colour = cut), size = 1)

# 6. 
# install.packages("ggbeeswarm")
library(ggbeeswarm)
?ggbeeswarm

ggplot(data = diamonds, aes(x = cut, y = price)) + 
  ggbeeswarm::geom_quasirandom(size = 1/10, alpha = 1/5) # very insightful

# ggplot(data = diamonds, aes(x = cut, y = price)) + 
#   ggbeeswarm::geom_beeswarm() ## sth wrong - very slow computing, I stopped it 

# 7.5.2 two categorical vars
# to vis the covariation between two cat vars we need to count
# the number of observations for each combination
# like in a crosstab

ggplot(data = diamonds) +
  geom_count(mapping = aes(cut, color))

diamonds %>% 
  count(color, cut)

diamonds %>% 
  count(color, cut) %>% 
  ggplot(aes(color, cut)) +
  geom_tile(aes(fill = n))

# plot tunning
diamonds %>% 
  count(color, cut) %>% 
  ggplot(aes(color, cut)) +
  geom_tile(aes(fill = -n)) +
  coord_flip()

# 7.5.2.1 excercises

# 1.

## show count
diamonds %>% 
  count(cut, color) %>% 
  ggplot(aes(color, n, group = cut, fill = cut)) +
  geom_col(position = "dodge", colour = "white")

diamonds %>% 
  count(cut, color) %>% 
  ggplot(aes(cut, n, group = color, fill = color)) +
  geom_col(position = "dodge", colour = "white")

diamonds %>% 
  count(cut, color) %>% 
  ggplot(aes(color, n, fill = cut)) +
  geom_col() +
  facet_grid(. ~ cut)

diamonds %>% 
  count(cut, color) %>% 
  ggplot(aes(cut, n, fill = color)) +
  geom_col() +
  facet_grid(. ~ color) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

## show prop 

# color by cut, 100% stacked bars
diamonds %>% 
  count(cut, color) %>% 
  ggplot(aes(color, n, group = cut, fill = cut)) +
  geom_col(position = "fill", colour = "white")

# cut by color, 100% stacked bars
diamonds %>% 
  count(cut, color) %>% 
  ggplot(aes(cut, n, group = color, fill = color)) +
  geom_col(position = "fill", colour = "white")

# color by cut, position dodge - easy to compare 
# how cuts are distributed in each color
diamonds %>%
  count(color, cut) %>%
  group_by(color) %>%
  mutate(prop = n / sum(n)) %>% 
  ggplot(aes(color, prop, group = cut, fill = cut)) +
  geom_col(position = "dodge", colour = "white") +
  scale_y_continuous(labels = scales::percent) +
  labs(caption = "each color = 100%")


# cut by color, position dodge - easy to compare 
# how colors are distributed in each cut
diamonds %>%
  count(color, cut) %>%
  group_by(cut) %>%
  mutate(prop = n / sum(n)) %>% 
  ggplot(aes(cut, prop, group = color, fill = color)) +
  geom_col(position = "dodge", colour = "white") +
  scale_y_continuous(labels = scales::percent) +
  labs(caption = "each cut = 100%")

# 2.Use geom_tile() together with dplyr to explore how average 
# flight delays vary by destination and month of year. 
# What makes the plot difficult to read? How could you improve it?

nycflights13::flights %>% 
  group_by(dest, month) %>% 
  summarise(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>% 
  ggplot(aes(x = month %>% as.factor(), y = dest)) +
  geom_tile(aes(fill = avg_arr_delay))

# improve by removing destinations
# with more than 2 empty months
# and different colours
flights %>% 
  group_by(dest, month) %>% 
  summarise(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>% 
  group_by(dest) %>% 
  filter(n() >= 10) %>% 
  ungroup() %>% 
  ggplot(aes(x = month %>% as.factor(), y = dest)) +
  geom_tile(aes(fill = avg_arr_delay)) +
  scale_fill_gradient(low = "orange", high = "blue")

# 3. because color (x axis) has more levels
# than cut (y axis), so it makes the plot
# wider than higher
# like more computer screens

# 7.5.3

smaller <- diamonds %>% 
  filter(carat < 3)

smaller %>% ggplot() +
  geom_bin2d(aes(carat, price))

smaller %>% ggplot() +
  geom_hex(aes(carat, price))

# those geoms above divide the coordinate plane into 2 dimensional bins
# and then use a fill color to display how many points
# fall into each bin

# we can bin just one variable to act like a discret / categorical one

smaller %>% ggplot() +
  geom_boxplot(aes(x = cut_width(carat, width = 0.1),
                   y = price)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# better solution - Hadley:

smaller %>% ggplot(aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_width(carat, width = 0.1)))

# disadvantage is that we don't see quantity of points
# One way to show that is to make the width 
# of the boxplot proportional to the number of points with
# varwidth


smaller %>% ggplot(aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_width(carat, width = 0.1)),
               varwidth = TRUE)

smaller %>% ggplot(aes(x = carat, y = price)) +
  geom_violin(aes(group = cut_width(carat, width = 0.25))) # not good

# another way is to display approx. same number of points in each bin

smaller %>% ggplot(aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_number(carat, n = 20))) 
### n in cut_number is a number of intervals to create

# 7.5.3.1 excercises

# 1.

smaller %>% ggplot(aes(x = price, colour = cut_width(carat, width = 0.5))) +
  geom_freqpoly(size = 1.5)
# bins are equal, but differs in number of points

smaller %>% ggplot(aes(x = price, colour = cut_number(carat, n = 10))) +
  geom_freqpoly(size = 1)
# number of points is equal for each bin, but bins are different in width
## both cases we should consider number of "categories" = bins created

# 2.

smaller %>% ggplot(aes(x = price, y = carat)) +
  geom_hex()

# 3.
# diamonds 0-1 carat have right-skeewed distributions, 
# relatively smaller variance in prices

# 1-2 are more symeric distributions
# higher variance

# 2-3 are left-skeewed
# highest variance

# 4.

smaller %>% ggplot(aes(x = carat, y = price, color = cut)) +
  geom_point(alpha = 0.5)

smaller %>% ggplot(aes(x = carat, y = price, color = cut)) +
  geom_point(alpha = 0.5) +
  geom_boxplot(aes(group = cut_width(carat, width = 0.1)))
  
smaller %>% ggplot(aes(x = cut_number(carat, n = 10),
                       y = price,
                       colour = cut)) +
  geom_boxplot()

smaller %>% ggplot(aes(x = carat, y = price)) +
  geom_bin2d() +
  facet_wrap( ~ cut, ncol = 1)

# 5.
# because on binned plot we lose accuracy on x axis

# 7.6 Patterns and models

faithful %>% ggplot(aes(eruptions, waiting)) + 
  geom_point()
# visible pattern: more eruptions asociated with longer
# waiting time. we see two clusters, <= 3.5 erupion and > 3.5

###################
# variation is a phenomenon that creates uncertanity,
# covariation is a phenomenon that reduces it.
##################

# models are a tool for extracting patterns from data
mod <- lm(log(price) ~ log(carat), data = diamonds)
summary(mod)
plot(mod)

diamonds_2 <- diamonds %>% 
  modelr::add_residuals(data = ., model = mod) %>% 
  mutate(resid = exp(resid))

ggplot(diamonds_2) +
  geom_point(aes(x = carat, y = resid))

ggplot(diamonds_2) +
  geom_boxplot(aes(x = cut, y = resid))
# because we "removed" stron relationship between carat and price,
# using the linear model,
# now it's visible that better quality diamonds are more expensive,
# relativeli to their size

# 7.7 ggplot2 calls

# explicit way:
ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_freqpoly(binwidth = 0.25)

# short way:
ggplot(faithful, aes(eruptions)) +
  geom_freqpoly(binwidth = 0.25)

### Typically, the first one or two arguments to a function
### are so important that you should know them by heart.

# be carefull for the transition
# from %>%  to +

diamonds %>% 
  count(cut, clarity) %>% 
  ggplot(aes(clarity, cut, fill = n)) +
  geom_tile()

# more help with ggplot2:
# http://www.cookbook-r.com/Graphs/