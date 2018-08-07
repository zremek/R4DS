# at some point you want to stop learning and start working
# with your own data

library(tidyverse)

# readr functions:
# read_csv() - comma delimited
# read_csv2() - semicolon separated
# read_tsv() - tab separated
# read_fwf() - fixed width files
# read_log() - Apache style log files

## all have similar syntax

write_csv(diamonds, "diamonds.csv") # save file
diamonds_csv <- read_csv("diamonds.csv") # read file

# inline csv file
read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

# skip metadata
read_csv(
  "The first line to skip
  The second one
  x,y,z
  6,7,8",
  skip = 2
)

# skip comment
read_csv(
  "# a comment to skip
  h,i,j,k
  65,78,44,29",
  comment = "#"
)

# when data has no column names:
# ommit colnames...
read_csv(
  "1,2,3\n4,5,6\n8,9,0", # \n is a shortcut for a new line
  col_names = FALSE
)

# ... pass colnames as a vector

read_csv(
  "1,2,3\n4,5,6\n8,9,0",
  col_names = c("first", "second", "third")
)

# specify NA's
read_csv(
  "1,2,3\n4,.,6\n.,8,.",
  na = "."
)

# methods above are sufficient for ~75% csv files in practice 

# 11.2.2 excercises
# 1. read_delim("my_file.csv", delim = "|")
write_delim(x = diamonds, 
            path = "diamonds_vertical_bar.csv",
            delim = "|") # save file

diamonds_vertical_bar <- read_delim(file = "diamonds_vertical_bar.csv",
                                    delim = "|") # read file
# 2.

# read_csv() and read_tsv() have all arguments in common:

# col_names = TRUE, col_types = NULL,
# locale = default_locale(), na = c("", "NA"), quoted_na = TRUE,
# quote = "\"", comment = "", trim_ws = TRUE, skip = 0, n_max = Inf,
# guess_max = min(1000, n_max), progress = show_progress()

# 3. # file and col_position

# 4. 
(frame <- read_delim(
  "x,y\n1,'a,b'",
  delim = ",",
  quote = "''",
  col_names = FALSE
))

# 5.
read_csv("a,b\n1,2,3\n4,5,6") 
# first line has only 2 data points, while others have 3
read_csv("a,b\n1,2,3\n4,5,6",
         skip = 1,
         col_names = FALSE) 

read_csv("a,b,c\n1,2\n1,2,3,4")
# first line 3 points, second 2, third 4 - NA's maybe?

read_csv("a,b\n\"1")
# strange '\"' inside second line

read_csv("a,b\n1,2\na,b")
# works but colnames are simmilar to second line of data

read_csv("a;b\n1;3")
# ";" as delimiter, use read_csv2()
read_csv2("a;b\n1;3")

# 11.3 Parsing a vector
c("TRUE", "FALSE", "NA") %>% parse_logical() %>% str()
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

# specify missing
parse_integer(c("1", "231", ".", "456"), na = ".")

# warnings
parse_warning <- parse_integer(c("123", "abc", "334", "33.23"))
parse_warning
problems(parse_warning) # get set of problems in a tibble

### using parsers is mostly a matter of understanding 
### what's available and how they deal with different types of input

# 11.3.1 parsing numbers

# problems with numbers:
# decimal mark could be "." or ","
# context characters like $ or %
# grouping characters like "," in 1,000,000 - they vary around the world

parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("$100")
parse_number("20%")
parse_number("It costs $124.45") #decimals work

parse_number("$123,456,345.99", # decimals rounds
             locale = locale(decimal_mark = ".",
                             grouping_mark = ","))
parse_number("1,234,567.78")
parse_number("123.456.789 zł", 
             locale = locale(grouping_mark = "."))


# 11.3.2 Parsing strings

# To understand what’s going on, 
# we need to dive into the details of how computers represent strings

charToRaw("Remigiusz")
charToRaw("Hadley")

# mapping from hexadecimal number to character is called encoding
# this is ASCII - American Standard Code ...
# for other languages UTF-8 is used widely
# readr uses UTF-8 everywhere
# it may cause problems for older systems

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
x1
x2

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

# guess encoding

guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

# resource about encoding:
# http://kunststube.net/encoding/

# 11.3.3 Parsing factors

fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "Banana"), levels = fruit)

# when there are many problematic entries,
# it's easier to use character vector
# and clean it later

# 11.3.4 Parsing dates, date-times, and times

parse_datetime("2010-10-10T2010")

# parser above expects datetime in ISO8601 form:
# year, month, day, hour, minute, second

parse_date("2010/10/10")
parse_date("2018-08-07")

# four digits year /|: two month /|: two day

require(hms) # library for classes of date-time data
parse_time("01:10 am")
parse_time("14:02")
parse_time("02:02 pm")

# we can use other formats with classes

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

parse_date("2 janvier 2015", "%d %B %Y", locale = locale("fr"))
parse_date("3 marca 2016", "%d %B %Y", locale = locale("pl"))

# 11.3.5 excercises
# 1.
?locale()
vignette("locales")
locale()

# 2. to finish!
parse_number("22,01", locale = locale(decimal_mark = ",", grouping_mark = ","))
parse_number("34.22,01", locale = locale(decimal_mark = ","))
