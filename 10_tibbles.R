# 10.1 Introduction

# Tibbles are data frames, but they tweak some older behaviours
# to make life a little easier. 
# R is an old language, and some things that were useful 10 or 20 years ago
# now get in your way.

library(tidyverse)

# coerce data.frame to tibble
as_tibble(iris)

# create a tibble from vectors
tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
)

# If you’re already familiar with data.frame(),
# note that tibble() does much less: 
# it never changes the type of the inputs 
# (e.g. it never converts strings to factors!), 
# it never changes the names of variables, and it never creates row names.

# It’s possible for a tibble to have column names that are not valid 
# R variable names, aka non-syntactic names. 
# For example, they might not start with a letter, 
# or they might contain unusual characters like a space. 
# To refer to these variables, you need to surround them with backticks ``

(tb <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
))

# use backticks in other pcgs - ggplot2, dplyr etc.

# transposed tibble is for easy data entry in code
tribble(
  ~x, ~y, ~z,
  ########### - this is to make clear where the header is
  "a", 2, 3.6,
  "b", 1, 8.5
)

# 10.3 tibbles vs. data.frame

# 10.3.1 printing
# tibble prints only 10 first rows, and all columns that fit the screen
# each column reports its type

tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

# to print more rows:
# print()
nycflights13::flights %>% 
  print(n = 20, width = Inf) # width=Inf == all columns

# use options(tibble.print_max = n, tibble.print_min = m)
# prints only m rows if more than n rows

## complete list of options:
package?tibble

# to see in a RStudio viewer
View(iris)

# 10.3.2 subsetting

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

df$x # exctract vector by name
df[["x"]]

df[[1]] # by position

df[, 1] # exctracts tibble
df[1]

# to use in pipe:
df %>% .$x
df %>% .[[1]]

diamonds %>% 
  filter(cut == "Ideal",
         carat < 3) %>% 
  .$color

# some older functions don't work with tibbles
# so we have to turn a tibble into data.frame

tb %>% as.data.frame() %>% class()

# 10.5 excercises
# 1.
print(mtcars) # n = 5 doesn't work
mtcars %>% as_tibble() %>% print(n = 5)
class(mtcars)
mtcars %>% as_tibble() %>% class() # check class

# 2.
df <- data.frame(
  abc = 1,
  xyz = "a"
)

df_t <- as_tibble(df)

df$x # no warning! partial matching?
df_t$x # warning - unknown column

df[, "xyz"]
df_t[, "xyz"]

df[, c("abc", "xyz")]
df_t[, c("abc", "xyz")]

# 3.
var <- "mpg"
mtcars %>% as_tibble() %>% select(var)

# 4.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

# 4.1
annoying %>% select(`1`)

# 4.2
annoying %>% ggplot(aes(x = `1`, y = `2`)) +
  geom_point()

# 4.3
annoying <- annoying %>% mutate(`3` = `2` / `1`)

# 4.4
annoying %>% rename(one = `1`,
                    two = `2`,
                    three = `3`)

# 5.
?tibble::enframe
# turn named vector into a two column tibble
islands
enframe(islands)

regular_slinky_strings <- c(.10, .13, .17, .26, .36, .46)
names(regular_slinky_strings) <- c("E", "B", "G", "D", "A", "E")
enframe(regular_slinky_strings)

mod <- lm(log(price) ~ log(carat), data = diamonds)
summary(mod) %>% enframe()

# 6.
library(nycflights13)
nycflights13::flights

# n_extra in print() controls
# how many additional coulmn names
# are printed at the footer:
nycflights13::flights %>% print(n_extra = 2)
nycflights13::flights %>% print(n_extra = 7)
