# http://r4ds.had.co.nz/transform.html

# 5.1.2 nycflighths13

install.packages("nycflights13")
library(nycflights13)

nycflights13::flights
head(flights[,12:19])
?flights
View(flights)


# 5.1.3 dplyr basics

### FIVE KEY DPLYR FUNCTIONS (verbs):
  # filter() - pick observarions by their values
  # arrange() - reorder the rows
  # select() - pick variables by their names
  # mutate() - create new variable with function of existing variables
  # summarise() - collapse many values down to a single summary

## all five can be used in conjunction with group_by(), 
## which changes the scope of each function 
## from operating on the entire dataset
## to operating on it group-by-group

## all five verbs work similarly:
  # 1. first argument is data frame
  # 2. next arguments describe what to do with data frame; var names without quotes
  # 3. result is a new data frame

# 5.2 filter rows

filter(flights, month == 1, day == 1)

(dec25 <- flights %>% filter(., month == 12, day == 25))

# 5.2.1 comparision

# using '==' to compare floating point numbers is not intuitive

1 == 1/23533 * 23533
1/21 * 21 == 1 # in the book such examples results false ;)
1/49 * 49 == 1 # this is false

sqrt(2)^2 == 2 # and this is false

pi == sqrt(pi ^ 2) # true
pi == sqrt(pi)^2 # false

## to avoid confussion, we may use near()

near(pi, sqrt(pi)^2)

# 5.2.2 logical operators

(X <- LETTERS[1:5])
(Y <- LETTERS[4:8])

ltr <- cbind.data.frame(X, Y)
View(ltr)

filter(ltr, X == 'A', Y == 'D') # default is AND...
filter(ltr, X == 'A' & Y == 'D') # ...so same result as above
filter(ltr, X == 'A' | Y == 'D') # in this case OR gives same as AND

filter(ltr, X == 'A', Y == 'A')

filter(ltr, X == 'A' & Y != 'A')

filter(ltr, X == 'D' | Y == 'D')
filter(ltr, X == 'D', Y == 'D')

filter(ltr, xor(X == 'A', Y == 'D'))
  # make it simplier
TRUE & FALSE
TRUE & TRUE
FALSE & FALSE

TRUE | FALSE
TRUE | TRUE
FALSE | FALSE

xor(TRUE, FALSE)
xor(TRUE, TRUE)
xor(FALSE, TRUE)
xor(FALSE, FALSE)

TRUE & !FALSE
TRUE & !TRUE
FALSE & !FALSE
FALSE & !TRUE

TRUE | !FALSE
TRUE | !TRUE
FALSE | !FALSE
!TRUE | !TRUE

xor(TRUE, !FALSE)
xor(TRUE, !TRUE)
xor(FALSE, !TRUE)
xor(FALSE, !FALSE)


## find all flights in november and december

(nov_dec <- flights %>% filter(month == 11 | month == 12))
summary(as.factor(nov_dec$month))


(nov_dec2 <- flights %>% filter(month %in% 11:12)) # 'x %in% y, z' is shorter form of 'x == y | x == z'
summary(as.factor(nov_dec2$month))

  # De Morgan's law:
    # !(x & y) == !x | !y
    # !(x | y) == !x & !y
!(TRUE & TRUE) == !TRUE | !TRUE
!(FALSE & TRUE) == !FALSE | !TRUE

!(FALSE | FALSE) == !FALSE & !FALSE
!(TRUE | FALSE) == !TRUE & !FALSE

## so filters below gives same results:

filter(flights, dep_delay <= 120, arr_delay <= 120)
filter(flights, !(dep_delay > 120 | arr_delay > 120))

# 5.2.3 missing values

NA > 5
NA == 1
NA *8 

NA == NA # confusing, but makes sense:
  ## when we don't know how big is A and how big is B, we still don't know if A equals B.

is.na(NA) # proper NA check

## filter() only includes rows where condition is TRUE; excludes both FALSE and NA's...
## ...but we can perserve NA's

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1) # no NA's

filter(df, x > 1 | is.na(x)) # include NA's

### 5.2.4 excercises

# 1.

    # Had an arrival delay of two or more hours
flights %>% filter(arr_delay >= 120)

    # Flew to Houston (IAH or HOU)
flights %>% filter(dest %in% c("IAH", "HOU"))

    # Were operated by United, American, or Delta
nycflights13::airlines # check codes

flights %>% filter(carrier %in% c("AA", "DL", "UA"))

    # Departed in summer (July, August, and September)
flights %>% filter(month %in% c(7:9))

    # Arrived more than two hours late, but didn’t leave late
flights %>% filter(arr_delay > 120, dep_delay <= 0)

    # Were delayed by at least an hour, but made up over 30 minutes in flight
flights %>% filter(dep_delay >= 60, arr_delay < 30)
    # Departed between midnight and 6am (inclusive)
flights %>% filter(between(dep_time, 1, 600))

# 3.
apply(flights, 2, function(x) sum(is.na(x))) %>% # count NA's for each variable
  sort(., decreasing = TRUE)                      # sort result in desc order

flights$dep_time %>% is.na() %>% table() # count just for one to check previous function

    ## check NA's correlation
fly <- as.data.frame(flights)
library(rattle)
rattle()
    ## from rattle log:
# The 'corrplot' package provides the 'corrplot' function.

library(corrplot, quietly=TRUE)

# Correlations work for numeric variables only.

naids <- attr(na.omit(t(crs$dataset[, c(crs$input, crs$risk, crs$target)])), "na.action")
crs$cor <- cor(is.na(crs$dataset[, c(crs$input, crs$risk, crs$target)][naids]), use="pairwise", method="pearson")

# Display the actual correlations.

print(crs$cor)
cat('\nCount of missing values:\n')
print(apply(is.na(crs$dataset[, c(crs$input, crs$risk, crs$target)][naids]),2,sum))
cat('\nPercent missing values:\n')
print(100*apply(is.na(crs$dataset[, c(crs$input, crs$risk, crs$target)][naids]), 2,sum)/nrow(crs$dataset[, c(crs$input, crs$risk, crs$target)]))

# Graphically display the correlations.

corrplot(crs$cor, mar=c(0,0,1,0))
title(main="Correlation of Missing Values\nfly using Pearson",
      sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))

# 4. 
NA | TRUE # A OR B results TRUE, when at least one side is TRUE; so result TRUE here
FALSE & NA # A AND B resuls TRUE only when two sides are TRUE; so FALSE here

NA^0
0^0 # it's consensus that is equals 1; 
    # some say'ideterminate form' http://mathforum.org/dr.math/faq/faq.0.to.0.power.html

  # x^n = 1 * x1 * x2 * .. * xn
  # x^0 = 1 

NA * 0 # result is NA

# 5.3 Arrange rows with arrange()

## arrange changes order of rows; we can provide more than one column to order by

arrange(flights, year, month, day, dep_time)

arrange(flights, desc(dep_delay)) # descending order

arrange(flights, desc(day), desc(dep_delay))

## missings are always sorted at the end

tmp <- data.frame(v1 = c(1, 4, NA, NA), v2 = c(3, 5, 4, NA), v3 = c(NA, 3, 4, 4))
tmp
arrange(tmp, v2)
arrange(tmp, v1)
arrange(tmp, desc(v2))
arrange(tmp, desc(v2), desc(v3))


# exercises:
#

# How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
# 
flights %>% filter(is.na(arr_delay)==TRUE) %>% arrange(arr_delay) # just filter works the same :) wrong idea

flights %>% arrange(desc(is.na(arr_delay)), arr_delay)

as.data.frame(flights[7:9]) %>% 
  arrange(desc(is.na(arr_delay)), arr_delay) %>% 
  write.table("flights_NA_first_1.csv") # first rows for is.na == 1, then is.na == 0, and for 0 ascending order

as.data.frame(flights[7:9]) %>% 
  arrange(desc(is.na(arr_delay))) %>% 
  write.table("flights_NA_first_2.csv") # like above, but no order for is.na == 0


# Sort flights to find the most delayed flights. Find the flights that left earliest.
# 
  # most delayed:
flights %>% arrange(desc(arr_delay))

  ## how many hours late are 3 most delayed?
install.packages("chron")
library(chron)

(minutes <- flights %>% arrange(desc(arr_delay)) %>% as.data.frame() %>% .[1:3, 9])
sub(":\\d{2}", "", times((minutes %/% 60 +  minutes %% 60 /3600)/24))
  
  
  # left earliest:
flights %>% arrange(dep_delay)

?flights
ggplot(flights, aes(dep_delay)) + geom_bar()
ggplot(flights, aes(dep_delay)) + geom_histogram(colour = "white")
ggplot(flights, aes(dep_delay)) + geom_bar(colour = "red") + geom_histogram(alpha = .5) # no sense :)
ggplot(flights) + geom_boxplot(aes(x = factor(1), y = dep_delay)) + coord_flip()

# Sort flights to find the fastest flights.
# 
flights %>% mutate(speed_miles_per_minutes = distance / air_time) %>% arrange(desc(speed_miles_per_minutes)) %>% .[1:5, c(1:6, 20)]

# Which flights travelled the longest? Which travelled the shortest?
flights %>% arrange(desc(air_time)) %>% .[1:5, 12:15] # longest air_time
flights %>% arrange(air_time) %>% .[1:5, 12:15] # shortest air_time

# 5.4 Select columns with select()

select(flights, year, month, day) # select by names
select(flights, year:dep_time) # all variables form year to dep_time (inclusive)
select(flights, -(year:dep_time)) # all except those form year to dep_time (inclusive)

## there are number of helper functions to be used with select:
flights %>% select(starts_with("ye")) # matches names that begin with "ye"
flights %>% select(ends_with("time")) # matches names that end with "time"
flights %>% select(contains("delay")) # matches names that contain "delay"
flights %>% select(matches("(.)\\1")) # selects variables that match a regular expresion

num_names <- data.frame(x_1 = seq(1, 2, length.out = 5),
                        x_2 = seq(10, 69, length.out = 5),
                        x_3 = seq(0.1, 90, length.out = 5),
                        x_4 = seq(8, 9, length.out = 5),
                        y_1 = seq(2, 34, length.out = 5),
                        y_2 = seq(1, 1.2, length.out = 5))
num_names %>% select(num_range("x_", 1:3))
num_names %>% select(num_range("y_", c(1,2))) # matches variables with given prefix and numbers

## for renaming we use rename(), which is a kind of select()
flights %>% rename(destination = dest, carrier_abr = carrier) # syntax: new_name = old_name

## for reorder it's easy to use select() with everything()
flights %>% select(time_hour,air_time, # those two goes to first and second position
                everything())
## excercises 5.4.1.
# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights

flights %>% select(contains("p_t"), contains("p_d"), contains("r_t"), contains("r_d"))
flights %>% select(contains("time"), contains("delay"))
flights %>% select(matches("^dep_"), matches("^arr_"))                   
flights %>% select(dep_time:arr_delay, -contains("sched"))

# 2. What happens if you include the name of a variable multiple times in a select() call?

flights %>% select(air_time, time_hour, air_time)
    # selects doubled names only once

# 3.What does the one_of() function do? Why might it be helpful in conjunction with this vector?

var <- c("year", "month", "day", "dep_delay", "arr_delay")

flights %>% select(one_of(var)) # selects names from a given vector

# 4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?
  
  select(flights, contains("TIME")) # seems to be not case sensitive!
  
flights %>% select(contains("TIME", ignore.case = FALSE)) # here we check flag F to make case sensitive

# 5.5. mutate() - add new variables
# http://r4ds.had.co.nz/transform.html#add-new-variables-with-mutate

flights_sml <- flights %>% select(year:day,
                                  ends_with("delay"),
                                  distance,
                                  air_time)
flights_sml %>% mutate(
  gain = arr_delay - dep_delay,
  speed = distance / air_time * 60,
  hours = air_time / 60,
  gain_per_hour = gain / hours
  )

  # when we just want to keep the new variables, use transmute()
transmute(flights_sml, 
          gain = arr_delay - dep_delay,
          speed = distance / air_time * 60,
          hours = air_time / 60,
          gain_per_hour = gain / hours
          )
  # transmute drops 'old' variables

# 5.5.1 useful creation functions

## function we use to create new variable with mutate,
## must be vectorised function:
## it must take a vector of values as input
## and return an output vector with the same length

# frequently useful functions:
  # arithmetic operators
  # modular arithmetic allows to break integers uo into pieces: 
    # %/% - integer division
    # %% - remainder
      # example to compute hour and minute form dep_time 

      flights %>% transmute(dep_time,
                            hour = dep_time %/% 100,
                            minute = dep_time %% 100)
      # more help: https://stackoverflow.com/questions/11670176/and-for-the-remainder-and-the-quotient
      
  # logs: log(), log2(), log10().
      # logs are useful transformation for dealing with data that ranges across multiple orders of magnitude
      # logs convert multiplicative relationship to additive; may be useful in modelling
  # offsets: lead() and lag() allow you to refer to leading or lagging values
      # running diference: x - lag(x)
      # value change: x != lag(x)
      d <- 1:10
      lag(d)
      lead(d)      
  # cumulative and rolling aggregates: cumsum(), cumprod(), cummin(), cummax(), dplyr::cummean()
d    
cumsum(d)  
d_prop <- d / sum(d)
cumsum(d_prop)  
cumprod(d) # cumulative product
cummax(d)  
cummin(d)
cummin(-d)
cummin(order(d, decreasing = TRUE))
cummean(d)         
  # logical comparisions: <, <=, >=, >, !=
  # ranking: usual type of ranking gives function min_rank()
y <- c(10, 20, 20, NA, 30, 40)
y[min_rank(y)[1]] # smallest rank to smallest value
min_rank(desc(y)) # highest rank to smallest value
?min_rank
    # min_rank is equivalent to rank(ties.method = "min")
    # it works as typical sports rank: with values equal (called "ties") 
    # ties.method = "min" gives minimum rank value to each element in set of tied values 
min_rank(c(1, 2,2,2,2,2,2, 3, 4, 4, 5))
min_rank(c(10,11,11,11,40,41,41,50,51,51,60))  
rank(c(10,11,11,11,40,41,41,50,51,51,60), ties.method = "min")
  # variants of rank are: row_number(), dense_rank(), percent_rank(), cume_dist(), ntile()
  
# 5.5.2 excercises

  
  
  # 1.Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. 
  # Convert them to a more convenient representation of number of minutes since midnight.
  # 
head(flights[,c("dep_time", "sched_dep_time")])
  
f_dep_minutes <- flights %>% mutate(
  dep_time_minutes_form_midnight = dep_time %/% 100 * 60 + dep_time %% 100,
  sched_dep_time_minutes_form_midnight = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100
  )
f_dep_minutes %>% select(contains("dep_time"))
  
  # Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
  #   
  transmute(flights, # compare
            air_time = air_time, # in minutes
            arr_time = arr_time,
            dep_time = dep_time,
            difference = arr_time - dep_time) # in strange format "hmm"
  
  transmute(flights, # fix
            air_time = air_time,
            arr_time = arr_time,
            dep_time = dep_time,
            air_time_minutes = (arr_time %/% 100 * 60 + arr_time %% 100) - (dep_time %/% 100 * 60 + dep_time %% 100), # difference in minutes, but not air_time!
            equal = air_time == air_time_minutes)
  
      # let's check https://jrnold.github.io/r4ds-exercise-solutions/
      # says that we need to account tz (it's correct due to ?flights: "dep_time,arr_time Actual departure and arrival times, local tz."),
      # but compares air_time with difference in strange format, doesn't compare to air_time_minutes as correctly done above!
  
  #   Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
  #
  hmm_to_minutes <- function(x) {x %/% 100 * 60 + x %% 100}
  
  flights %>% mutate(
    dep_delay2 = hmm_to_minutes(dep_time) - hmm_to_minutes(sched_dep_time)
  ) %>% 
    select(dep_time,
         sched_dep_time,
         dep_delay,
         dep_delay2)
  
  #   Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().
  flights %>% mutate(
    delay_rank = min_rank(desc(dep_delay))
  ) %>% filter(delay_rank <= 10) %>% select(dep_delay, delay_rank) %>% arrange(delay_rank)
  
  top_n(x = flights, n = 10, wt = dep_delay) %>% select(dep_delay) %>% arrange(desc(dep_delay)) # wraper
  
  top_n(x = data.frame(var = c(1,2,2,2,2,2,2,2,3,3,3,4,5,6,7,23,56)), n = -5) # includes more than n rows if there are ties.
  # What does 1:3 + 1:10 return? Why?
  #   
  1:3 + 1:10 # 1:3 is a c(1,2,3) and so on; addition is vectorised with warning
  a <- 1:3
  b <- 1:10
  a+b # same result
  
  #   What trigonometric functions does R provide?
    ?sin
  # cos(x)
  # sin(x)
  # tan(x)
  # 
  # acos(x)
  # asin(x)
  # atan(x)
  # atan2(y, x)
  # 
  # cospi(x)
  # sinpi(x)
  # tanpi(x)
  
# 5.6 summarise() - the last key verb
  
# collapse data frame to a single row:
  summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
# summarise() is useful with group_by()
# it changes the unit of analysis from whole data frame to groups
  
(average_delay_by_day <- flights %>% 
  group_by(year, month, day) %>% # group_by is done first
  summarise(delay = mean(dep_delay, na.rm = TRUE))) # summarise is second

# 5.6.1 the pipe
  # good way to pronounce '%>%' is 'then', so..
  # ... group, then summarise, then filter:
  
  (delays <- flights %>% 
    group_by(dest) %>% 
    summarise(
      count = n(),
      dist = mean(distance, na.rm = TRUE),
      delay = mean(arr_delay, na.rm = TRUE)
    ) %>% 
    filter(count > 20, dest != "HNL"))
      # plot
  ggplot(delays, aes(x = dist, y = delay, label = dest)) +
    geom_point(aes(size = count), alpha = 1/4) +
    geom_smooth(se = FALSE) +
    geom_text(check_overlap = TRUE, vjust = 1)
  
  ### Working with the pipe 
  ### is one of the key criteria 
  ### for belonging to the tidyverse
  
# 5.6.2 missing values http://r4ds.had.co.nz/transform.html
  
# above na.rm = TRUE was used
# let's do without it
  flights %>% 
    group_by(year, month, day) %>% 
    summarise(mean_delay = mean(dep_delay))
# we get NA's because aggregation functions obey the usual rule of NA'S:
# any NA in input gives NA in output

# to avoid it we use na.rm = T
# it removes NA's prior to computation
  flights %>% 
    group_by(year, month, day) %>% 
    summarise(mean_delay = mean(dep_delay, na.rm = TRUE))
# missing values represent cancelled flights,
# so we should consider it
  not_cancelled <- flights %>% 
    filter(!is.na(dep_delay), !is.na(arr_delay))
  
  not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(mean_dep_delay = mean(dep_delay))
  # why are means lower?
  # maybe there are flights with dep_delay, and no arr_delay?
  flights %>% 
    filter(!is.na(dep_delay), is.na(arr_delay)) %>% 
    select(dep_delay, arr_delay) # yes
  
# 5.6.3 counts
  # always include a count 'n()' or a count of non-missings 'sum(!is.na(x))'
  # when aggregating
  
  # let's look at the planes' average delay
  
  planes_delays <- not_cancelled %>% 
    group_by(tailnum) %>% 
    summarise(mean_arr_delay = mean(arr_delay))
ggplot(planes_delays, aes(x = mean_arr_delay)) + geom_freqpoly()  
  # there are some planes that have avg delay of 300 minutes...
  # ... but those planes have few flights
planes_delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(mean_arr_delay = mean(arr_delay),
            n_flights = n())
ggplot(planes_delays, aes(x = n_flights, y = mean_arr_delay)) + 
  geom_point(alpha = 1/10)
  ## there is much greater variation in the average delay when there are few flights
  ## plot has very common shape for a summary vs. group size
  ## variation decreases as the group size increases
  
# check this relation without smallest groups with the largest variation

planes_delays %>% 
  filter(n_flights > 25) %>% 
  ggplot(aes(n_flights, mean_arr_delay)) +
  geom_point(alpha = 1/10)

# similar pattern
install.packages("Lahman")
library(Lahman)

battin <- as_tibble(Lahman::Batting)

batters <- battin %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(aes(ab, ba)) +
  geom_point(alpha = 1/5) +
  geom_smooth()

batters %>% 
  ggplot(aes(ab, ba)) +
  geom_point(alpha = 1/5) +
  geom_smooth()

#This also has important implications for ranking. 
#If you naively sort on desc(ba), 
#the people with the best batting averages are clearly lucky, 
#not skilled:
  
  batters %>% 
  arrange(desc(ba)) # one | two hits, ba = 1
  
# You can find a good explanation of this problem at 
# http://varianceexplained.org/r/empirical_bayes_baseball/ 
# and http://www.evanmiller.org/how-not-to-sort-by-average-rating.html.
  
# 5.6.4 useful summary functions
  # median()
  # logical subsetting
  
  not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(
      avg_delay = mean(arr_delay),
      avg_delay_positive = mean(arr_delay[arr_delay > 0]), # only + delay
      avg_delay_negative = mean(arr_delay[arr_delay < 0]), # only - delay
      n_flights = n()
    )
  
  # measures of spread: sd(), IQR(), mad() - median absolute deviation
  ?mad()
    # check variability of distance in destinations
  distance_sd <- not_cancelled %>% 
    group_by(dest) %>% 
    summarise(distance_sd = sd(distance), n_flights = n()) %>% 
    arrange(desc(distance_sd))
    # plot it
  library(forcats)
  distance_sd %>%  
    ggplot(aes(x = forcats::fct_reorder(f = dest, x = distance_sd, fun = max), y = distance_sd)) +
    geom_point(aes(size = n_flights), alpha = 1/5) +
    coord_flip()
  
  ggplot(distance_sd, aes(x = n_flights, y = distance_sd)) +
    geom_point(alpha = 1/2) +
    geom_smooth()
  
  # measures of rank min(), max(), quantile(x, 0.25)
    # when do the first and last flights leave each day?
  first_last_day <- not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(
      first = min(dep_time),
      last = max(dep_time),
      date = min(format(time_hour, "%Y %m %d") %>% as.Date(format = "%Y %m %d"))
    )
    # plot
  ggplot(first_last_day) +
    geom_point(aes(x = date, y = first), colour = "orange", size = 3, alpha = 1/2) + 
    geom_point(aes(x = date, y = last), colour = "blue",  size = 3, alpha = 1/2)
  
  ggplot(first_last_day) +
    geom_path(aes(x = date, y = first), colour = "orange", size = 1) + 
    geom_path(aes(x = date, y = last), colour = "blue", size = 1)
  
  #measures of position: first(), last(), nth(x, 2)
  first_last_day2 <- not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(
      first = first(dep_time),
      last = last(dep_time)
      )
      # it gives here same results as min max
  (first_last_day$first == first_last_day2$first) %>% summary()
  (first_last_day$last == first_last_day2$last) %>% summary()
  
      # filtering on ranks - gives you all variables, with each observation in a separate row
  not_cancelled %>% 
    group_by(year, month, day) %>% 
    mutate(r = min_rank(desc(dep_time))) %>% 
    filter(r %in% range(r)) %>% 
    select(year:dep_time, r)
  
  # counts: n(), sum(!is.na(x)), n_distinct(x)
    # which destination have most carriers?
  not_cancelled %>% 
    group_by(dest) %>% 
    summarise(n_carr = n_distinct(carrier)) %>% 
    arrange(desc(n_carr)) %>% 
    ggplot(aes(x = forcats::fct_reorder(dest, n_carr, max), y = n_carr)) +
    geom_col()
  
    # helper for quick count
  not_cancelled %>% 
    count(dest)
      # when was the most flights?
  not_cancelled %>% 
    count(year, month, day) %>% 
    arrange(desc(n))
    
    # weight can be provided - 
    # we sum miles of each plane flew
  not_cancelled %>% 
    count(tailnum, wt = distance)
      # same result (a line more)
  not_cancelled %>% 
    group_by(tailnum) %>% 
    summarise(dist = sum(distance))
  
  # counts and proportions of logical values
   # When used with numeric functions, 
    # TRUE is converted to 1 and FALSE to 0. 
    # This makes sum() and mean() very useful: 
    # sum(x) gives the number of TRUEs in x, 
    # and mean(x) gives the proportion.
  
    # how many flights left before 5 am each day?
  not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(n_early_5am = sum(dep_time < 500))
  
  # what is the proportion of flights delayed more than an hour each day?
  arr_delay_one_hour <- not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(delay_above_1h_prop = mean(arr_delay > 60))
  # plot
  plot(arr_delay_one_hour$delay_above_1h_prop)
  
# 5.6.5 http://r4ds.had.co.nz/transform.html
# grouping by multiple variables
  # each summary peels off one level of the grouping
  (dialy <- flights %>% 
      group_by(year, month, day) %>% 
      summarise(flights = n()))
  
  (monthly <- dialy %>% summarise(flights = sum(flights)))  
  
  (yearly <- monthly %>% summarise(flights = sum(flights)))
  
  ## Be careful when progressively rolling up summaries: it’s OK for sums and counts, 
  # but you need to think about weighting means and variances, 
  # and it’s not possible to do it exactly for rank-based statistics like the median. 
  # In other words, the sum of groupwise sums is the overall sum, 
  # but the median of groupwise medians is not the overall median.
  
# 5.6.6 ungrouping
  
  dialy %>% ungroup() %>% summarise(flights = sum(flights)) # the grouping doesn't work any more
  
    class(dialy) # "grouped_df"
    dialy %>% ungroup() %>% class() # tbl_df
    
# 5.6.7 excercises
    
    # 1. Which is more important: arrival delay or departure delay?
    
    d_t_a <- flights %>% mutate(
      dep_then_arr_delay = dep_delay > 0 & arr_delay > 0
    ) 
    
    sum(d_t_a$dep_then_arr_delay, na.rm = TRUE) / sum(d_t_a$arr_delay > 0, na.rm = TRUE) 
    
    # above 69% of arr delayed flights are also dep delayed...
    # ... so departure delay is more important,
    # because it's hard to avoid arr delay (which is bad for customers)
    # when a flight is delayed at departure
    
    # 2. give the same output
    
    not_cancelled %>% count(dest) 

    not_cancelled %>% 
      group_by(dest) %>% 
      summarise(n = n())
    
    not_cancelled %>% count(tailnum, wt = distance)
    
    not_cancelled %>% 
      group_by(tailnum) %>% 
      summarise(n = sum(distance))
    
    # 3. which is the most important feature to identify 
    # a cancelled flight?
    
    ?flights
    
    flights %>% filter(
      is.na(arr_delay),
      !is.na(arr_time)
    ) %>% select(
      air_time, dep_delay, arr_delay, dep_time, arr_time
    )
  
    apply(flights, 2, function(x) sum(is.na(x)))  
    # I thing it is arr_time
    
    # 4. Look at the number of cancelled flights per day. 
    # Is there a pattern? - no
    # Is the proportion of cancelled flights related to the average delay? - yes! positive linear relation, maybe x^2
    
    f_with_cancelled <- flights %>% mutate(
      is_cancelled = is.na(dep_delay) | is.na(arr_delay)
    )

    (cancelled_per_day <- f_with_cancelled %>% 
        group_by(year, month, day) %>% 
        summarise(n_cancelled = sum(is_cancelled),
                  avg_dep_delay = mean(dep_delay, na.rm = TRUE),
                  avg_arr_delay = mean(arr_delay, na.rm = TRUE),
                  prop_cancelled = mean(is_cancelled, na.rm = TRUE),
                  date = min(format(time_hour, "%Y %m %d"))) %>% 
        mutate(weekday = weekdays(x = date %>% as.Date(format = "%Y %m %d"))))    
    
    ggplot(cancelled_per_day, aes(x = date %>% as.Date(format = "%Y %m %d"), y = n_cancelled)) +
      geom_point(aes(colour = weekday), size = 4, alpha = 2/3)

    ggplot(cancelled_per_day, aes(x = weekday, y = n_cancelled)) +
      geom_boxplot()
    ggplot(cancelled_per_day, aes(x = as.factor(month), y = n_cancelled)) +
      geom_boxplot()
    ggplot(cancelled_per_day, aes(x = as.factor(day), y = n_cancelled)) +
      geom_boxplot()    
    
    ggplot(cancelled_per_day, aes(x = date %>% as.Date(format = "%Y %m %d"), y = prop_cancelled)) +
      geom_point(aes(colour = weekday), size = 4, alpha = 2/3)
    
    ggplot(cancelled_per_day, aes(x = weekday, y = prop_cancelled)) +
      geom_boxplot()
    ggplot(cancelled_per_day, aes(x = as.factor(month), y = prop_cancelled)) +
      geom_boxplot()
    ggplot(cancelled_per_day, aes(x = as.factor(day), y = prop_cancelled)) +
      geom_boxplot()    
    
    ggplot(cancelled_per_day, aes(x = prop_cancelled, y = avg_arr_delay)) +
      geom_point() +
      geom_smooth()

    ggplot(cancelled_per_day, aes(x = prop_cancelled, y = avg_dep_delay)) +
      geom_point() +
      geom_smooth()
    
    # 5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers?
    
    # carrier with worst delays: F9 FL
    flights %>% group_by(carrier) %>% summarise(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>% arrange(desc(avg_arr_delay))
    
    flights %>% group_by(carrier, dest) %>% summarise(n())
    
    # disentangle the effects of bad airports vs. bad carriers
    (carrier_dest <- flights %>% 
      group_by(carrier, dest) %>% 
      summarise(avg_arr_delay = mean(arr_delay, na.rm = TRUE), 
                n = n()) %>% 
      arrange(desc(avg_arr_delay)))

    plot(table(carrier_dest$dest, carrier_dest$carrier))
    
    # 6. sort() in count?
    
    ?count()
    # sort	if TRUE will sort output in descending order of n
    
    flights %>% count(carrier, sort = TRUE) # good to check highest/smallest n of group - shortcut to arrange()
    

# 5.7 grouped mutates and filters
    
    # 9 highest arr_delay ranks for each day
    flights_sml %>% 
      group_by(year, month, day) %>% 
      filter(rank(desc(arr_delay)) < 10)
    
    flights_sml %>% 
      group_by(year, month, day) %>% 
      filter(rank(desc(arr_delay)) < 10) %>% 
      summarise(n = n()) %>%
      mutate(n_f = as.factor(n)) %>%
      summary()
      # there are 340 days with 9 delays, 10 with 23 and 8 with 2
    
    # destinantions with more than 10000 flights
    flights %>% 
      group_by(dest) %>% 
      filter(n() > 10000) %>% 
      summarise(n_flights = n()) %>% 
      arrange(n_flights)
    
    library(forcats)
    flights %>% 
      group_by(dest) %>%
      summarise(n_flights = n()) %>% 
      ggplot(aes(x = forcats::fct_reorder(dest, n_flights, max), y = n_flights)) +
      geom_col(aes(fill = n_flights > 10000)) +
      coord_trans(y = "sqrt") +
      theme(axis.text.x = element_text(angle = 90))
    
      # help for ggplot2:
      # http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/
      # https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
    
      # compute per group metrics:
          # how many dests we have? - 105
flights$dest %>% as.factor() %>% str()
          # take dests with more than 365 flights
(popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365))
          # check how big is the prop of each flight's arr_delay 
          # is sum of this delay in each group
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay) %>% 
  summarise(sum_prop = sum(prop_delay)) 
        # shows that above we computed correcty - each group sums up to 1
        
        # A grouped filter is a grouped mutate followed by an ungrouped filter. 
        # I generally avoid them except for quick and dirty manipulations: 
        # otherwise it’s hard to check that you’ve done the manipulation correctly.
        
        # Functions that work most naturally in grouped mutates and filters 
        # are known as window functions (vs. the summary functions used for summaries). 
        # You can learn more about useful window functions in the corresponding vignette: vignette("window-functions").
        
# 5.7.1 excercises
  # 1. Refer back to the lists of useful mutate and filtering functions. 
  # Describe how each operation changes when you combine it with grouping.

  # filter() combined with group_by() filters in groups, for instance max
  # mutate() creates new variables in groups, for instance prop of some value in sum for the group

  # 2. Which plane (tailnum) has the worst on-time record?
flights %>% 
  filter(rank(desc(arr_delay)) == 1) %>% 
  select(arr_delay, tailnum)

  # 3. What time of day should you fly 
  # if you want to avoid delays as much as possible?
ggplot(flights, aes(x = hour %>% as.factor(), y = arr_delay)) +
  geom_boxplot()

flights %>% 
  group_by(hour) %>% 
  summarise(avg_arr_d = mean(arr_delay, na.rm = TRUE)) %>% 
  arrange(avg_arr_d)
  ## you should arrive beetwen 5 - 9 AM

  # 4. a) For each destination, compute the total minutes of delay. 
  # b) For each, flight, compute the proportion of the total delay for its destination.

flights %>% # a)
  group_by(dest) %>% 
  summarise(sum_arr_d = sum(arr_delay, na.rm = TRUE)) 

flights %>% # b)
  group_by(dest) %>% 
  mutate(prop_arr_d_in_dest = arr_delay / sum(arr_delay, na.rm = TRUE)) %>% 
  select(contains("arr_d"))

flights %>% # b) check
  group_by(dest) %>% 
  mutate(prop_arr_d_in_dest = arr_delay / sum(arr_delay, na.rm = TRUE)) %>% 
  summarise(sum(prop_arr_d_in_dest, na.rm = TRUE)) %>% 
  View() # there is LGA == 0, so sth wrong

flights %>% filter(dest == "LGA") # just one flight, seems to be cancelled

flights %>% # b) with filter
  filter(!is.na(arr_time)) %>% 
  group_by(dest) %>% 
  mutate(prop_arr_d_in_dest = arr_delay / sum(arr_delay, na.rm = TRUE)) %>% 
  select(contains("arr_d"))

flights %>% # b) check
  filter(!is.na(arr_time)) %>%
  group_by(dest) %>% 
  mutate(prop_arr_d_in_dest = arr_delay / sum(arr_delay, na.rm = TRUE)) %>% 
  summarise(sum(prop_arr_d_in_dest, na.rm = TRUE)) %>% 
  summary() # now ok

  # 5. Using lag() explore how the delay of a flight is related 
  # to the delay of the immediately preceding flight.

flights %>% 
  filter(!is.na(arr_time)) %>% 
  mutate(lag_arr_d = lag(arr_delay)) %>% 
  ggplot(aes(x = lag_arr_d, y = arr_delay)) +
  geom_point(alpha = 1/5) +
  geom_smooth() # weak relation
  
  # maybe we should do some arrange - arr_time
flights %>% 
  filter(!is.na(arr_time)) %>% 
  arrange(year, month, day, arr_time) %>% 
  mutate(lag_arr_d = lag(arr_delay)) %>% 
  ggplot(aes(x = lag_arr_d, y = arr_delay)) +
  geom_point(alpha = 1/5) +
  geom_smooth() # similar weak relation

  # another arrange - sched_arr_time
flights %>% 
  filter(!is.na(arr_time)) %>% 
  arrange(year, month, day, sched_arr_time) %>% 
  mutate(lag_arr_d = lag(arr_delay)) %>% 
  ggplot(aes(x = lag_arr_d, y = arr_delay)) +
  geom_point(alpha = 1/5) +
  geom_smooth() # weak

  # solution from https://github.com/maxconway/r4ds_solutions/blob/master/transform_solutions.Rmd
flights %>%
  mutate(new_sched_dep_time = lubridate::make_datetime(year, month, day, hour, minute)) %>%
  group_by(origin) %>%
  arrange(new_sched_dep_time) %>%
  mutate(prev_flight_dep_delay = lag(dep_delay)) %>%
  ggplot(aes(x=prev_flight_dep_delay, y= dep_delay)) + geom_point() # seems realy similar

# 6.
  # suspiciously fast in dest
flights %>% 
  group_by(dest) %>% 
  filter(min_rank(air_time) %in% c(1, 2)) %>% 
  select(dest, air_time) %>% View()

  # Compute the air time a flight relative to the shortest flight to that destination
flights %>% 
  group_by(dest) %>% 
  filter(!is.na(air_time))
  mutate(relative_min_air_time = 
           air_time / min(air_time)) %>% 
  select(dest, air_time, relative_min_air_time) %>% 
  arrange(dest, desc(relative_min_air_time))

  # most delayed in the air?
  flights %>% 
    group_by(dest) %>% 
    filter(!is.na(air_time)) %>% 
    mutate(relative_min_air_time = 
             air_time / min(air_time),
           air_delay = arr_delay - dep_delay) %>% 
    filter(min_rank(desc(air_delay)) == 1) %>% 
    select(dest, air_time, relative_min_air_time, air_delay, tailnum) %>% 
    arrange(dest, desc(air_delay))
  # maybe air_delay is related to relative_min_air_time?
flights %>% 
  group_by(dest) %>% 
  filter(!is.na(air_time)) %>% 
  mutate(relative_min_air_time = 
           air_time / min(air_time),
         air_delay = arr_delay - dep_delay) %>% 
  ggplot(aes(x = relative_min_air_time, y = air_delay)) +
  geom_point(aes(colour = dest), alpha = 1/2)

# 7. Find all destinations that are flown by at least two carriers. 
# Use that information to rank the carriers

  # count carriers for dest
(carriers_for_dest <- flights %>% 
  group_by(dest, carrier) %>% 
  count(dest) %>% 
  group_by(dest) %>% 
  count(dest))

  # oldshool way
by(flights$carrier, flights$dest, function(x) x %>% unique() %>% length())

flights$carrier %>% unique() %>% length() # 16 carriers

  # flown by at least two carriers and rank carriers
carriers_for_dest %>% 
  filter(nn >= 2) %>% 
  mutate(n_carriers = nn,
         rank_dest = min_rank(desc(n_carriers))) %>% 
  arrange(rank_dest)

# 8. For each plane, count the number of flights before the first delay of greater than 1 hour.
## ile razy leciał samolot, zanim miał opóźnienie powyżej godziny

flights$tailnum %>% unique() %>% length() # 4044 flights

#### this solution seems to be wrong
(over_60 <- flights %>% 
  group_by(tailnum) %>% 
  mutate(arr_d_over_60 = arr_delay > 60,
         time_order = min_rank(time_hour),
         is_time_over_60 = time_order * arr_d_over_60))
  
  over_60 %>% 
    filter(is_time_over_60 != 0) %>% 
    summarise(before_60 = min(is_time_over_60)) %>% 
    arrange(desc(before_60))
####
  
  # from https://github.com/maxconway/r4ds_solutions/blob/master/transform_solutions.Rmd
  
flights %>%
  mutate(dep_date = lubridate::make_datetime(year, month, day)) %>%
  group_by(tailnum) %>%
  arrange(dep_date) %>%
  filter(!cumany(arr_delay>60)) %>%
  tally(sort = TRUE)

?cumany # all rows after first TRUE
?tally # "zestawienie"; count on grouped tbl
        # so: summarise(n = n()) %>% arrange(desc(n)) gives same result as tally(sort = TRUE)

# my final solution
flights %>% 
  group_by(tailnum) %>% 
  arrange(time_hour) %>% 
  filter(!cumany(arr_delay > 60)) %>% 
  tally(sort = TRUE)
