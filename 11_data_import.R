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

# 2.1
parse_number("22,01", locale = locale(decimal_mark = ",", grouping_mark = ","))
parse_double("22,01", locale = locale(decimal_mark = ",", grouping_mark = ","))
  # Error: `decimal_mark` and `grouping_mark` must be different
  # in parse_number the grouping mark specified by the locale is ignored inside the number
# 2.2
parse_double("3,422.01", locale = locale(decimal_mark = ".", grouping_mark = ","))
  # above grouping mark causes error
parse_number("3,422.01", locale = locale(decimal_mark = ".", grouping_mark = ","))
  # ok
parse_number("3.422,01", locale = locale(decimal_mark = ","))
  # ok, so "." is recognised as grouping mark - default grouping changes to "."
locale(decimal_mark = ",")

parse_number("3'422,01", locale = locale(decimal_mark = ","))
  # wrong parsed to 3, no warnings
# 2.3
parse_number("3.422,01", locale = locale(grouping_mark = "."))
  # ok, so default decimal changes to ","
locale(grouping_mark = ".")


# 3.
?locale
?date_format
?strptime # all formats

strange_date_time <- "98--11--29 02:25:04 pm"
parse_datetime(strange_date_time, "%y--%m--%d %I:%M:%S %p")

parse_date("98--11--29", locale = locale(date_format = "%y--%m--%d"))
parse_time("02:25:04 pm", locale = locale(time_format = "%I:%M:%S %p"))

# parse_datetime(strange_date_time,
#                locale = locale(
#                  date_format = "%y--%m--%d ",
#                  time_format = "%I:%M:%S %p")
#                )
## doesn't work

# 4.
czech_locale <- locale(date_format = "%d.%m.%Y")
parse_date("02.08.1987", locale = czech_locale)

# 5.
# read_csv2() uses ";" as a separator, instead of ","
# it's for Europe, where "," is decimal mark

# 6.
# UTF-8 and sometimes UTF-16 are used both in Europe and Asia
# in Europe ISO/IEC 8859 is used; is has few part,
# for instance Latin-1, Latin-2 (see: https://en.wikipedia.org/wiki/ISO/IEC_8859)
# in Asia China has GB 18030 (see: https://en.wikipedia.org/wiki/GB_18030)
# in Japan - Shift JIS (see: https://www.sljfaq.org/afaq/encodings.html)

# 7.
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, "%B%e, %Y")
parse_date(d2, "%Y-%b-%d")
parse_date(d3, "%d-%b-%Y")
parse_date(d4, "%B %d (%Y)")
parse_date(d5, "%m/%d/%y")
parse_time(t1, "%H%M")
parse_time(t2, "%H:%M:%OS %p")

# 11.4 parsing a file

# how readr package guesses the type of each column
# how to override the default specification

guess_parser("2010-10-10")
guess_parser("15:01")
guess_parser(c(TRUE, FALSE))
guess_parser(1:5)
guess_parser(seq(0.1, 1, 0.01))
guess_parser("100,000.01") # number - has grouping marks

str(parse_guess("2010-10-10"))
parse_guess("2010-10-10")

challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)
problems(challenge) %>% filter(col == "y") # no problems with y col

challenge <- read_csv(
  readr_example("challenge.csv"),
                col_types = cols(
                  x = col_double(),
                  y = col_character()
                  )
                )
head(challenge)
tail(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)

challenge %>% summary()

# every parse_xyz() has a corresponding col_xyz() function
# parse_ is used for parsing a vector that we have in R
# col_ is for data load to R

# I highly recommend always supplying col_types, 
# building up from the print-out provided by readr

challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
challenge2 # works because we checked one more row in read_csc()

# read all cols as char

challenge3 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character())
                       )
challenge3 <- type_convert(challenge3) 
# type_conver applies the parsing heuristic

df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
type_convert(df)

# while reading big file, set n_max in read_csv to small number like 10^3,
# to make first reading iterations faster
# read a whole file when col types are well known

# if big parsing problems, first read into char vector
# using read_lines(), or ch vector of lenhth 1 - read_file()
# then use parsing functions

# 11. 5 Writing to a file

# write_csv() and write_tsv()
# both save strings in UTF-8, dates in ISO8601

# for excel use write_excel_csv()

# reminder - writing csv causes lost of col types
write_csv(challenge, "challenge_write.csv")
read_csv("challenge_write.csv") # 1000 parsing failrues

# store in R binary data format RDS
write_rds(challenge, "challenge.rds")
read_rds("challenge.rds") # col types saved

# the feather pcg for fast, shareable binary data format 
### problems with installing (Rtool installed):
# install.packages("feather", dependencies = TRUE)
# library(feather)

# 11.6 other data types:

## For rectangular data:
#   
# haven reads SPSS, Stata, and SAS files.
# 
# readxl reads excel files (both .xls and .xlsx).
# 
# DBI, along with a database specific backend (e.g. RMySQL, RSQLite, 
#                                              RPostgreSQL etc)
# allows you to run SQL queries against a database and return a data frame.
# 
## For hierarchical data: use jsonlite (by Jeroen Ooms) for json, and xml2 for XML.
# Jenny Bryan has some excellent worked examples at 
# https://jennybc.github.io/purrr-tutorial/.
# 
# For other file types, try the R data import/export manual and the rio package.
