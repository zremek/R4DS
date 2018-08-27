# There are three interrelated rules which make a dataset tidy:
#   
# Each variable must have its own column.
# Each observation must have its own row.
# Each value must have its own cell.

# 12.2.1 excercises

# 1.
# in table1 observation unit is country*year (3*2 = 6 rows)
# four variables: country, year, cases, population

# in table2 observation unit is country*year*type (3*2*2 = 12 rows)
# also 4 variables, but "type" stores information cases or population,
# count gives a number of cases of population

# in table 3 obs unit is same as in table 3,
# but informations about cases and population are stored in one variable,
# as a string

# in table 4a observation unit is a country, so 3 rows,
# variables are years, so two: 1999 and 2000,
# stored values are number of cases

# in table 4b situation is same as in 4a,
# except values: number of population

# 2.
table1 %>% 
  mutate(rate = cases / population * 10000)

cases2 <- table2 %>% filter(type == "cases") %>% 
  rename(cases = count)

population2 <- table2 %>% filter(type == "population") %>% 
  rename(population = count)

cases2$rate2 <- cases2$cases / population2$population * 10000

# table2 is much harder to work with, because we need to create
# new, helper datasets instead of just add a variable to  

table4_rate <- table4a
table4_rate$r_1999 <- table4a$`1999` / table4b$`1999` * 10000
table4_rate$r_2000 <- table4a$`2000` / table4b$`2000` * 10000

(tmp_00 <- table4_rate %>% select(country, contains(match = "00")) %>% 
  mutate(year = "2000") %>% rename(cases = `2000`, rate = r_2000))
(tmp_99 <- table4_rate %>% select(country, contains(match = "99")) %>% 
  mutate(year = "1999") %>% rename(cases = `1999`, rate = r_1999))

table4_rate <- rbind(tmp_00, tmp_99)
(table4_rate <- arrange(table4_rate, country, year))

# 3.
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))
# recreate
ggplot(filter(table2, type == "cases"), aes(year, count)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

# 12.3

# For most real analyses, you’ll need to do some tidying. 
# The first step is always to figure out what the variables and observations are. 
# Sometimes this is easy; other times you’ll need to consult with the people who 
# originally generated the data. The second step is to resolve one of two common problems:
#   
# One variable might be spread across multiple columns.
# 
# One observation might be scattered across multiple rows.
# 
# Typically a dataset will only suffer from one of these problems; 
# it’ll only suffer from both if you’re really unlucky! 
# To fix these problems, you’ll need the two most important functions
# in tidyr: 
# gather() and spread().

# 12.3.1 Gathering

tidy4a <- table4a %>% gather(`1999`, `2000`, key = year, value = cases)
tidy4b <- table4b %>% gather(`1999`, `2000`, key = year, value = population)

# join
left_join(tidy4a, tidy4b)

# 12.3.2 Spreading

table2 %>% spread(key = type, value = count)

# 12.3.3 excercises

# 1
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks

stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)

# "year" is now stored as character...
stocks %>% 
  spread(year, return)
#... because year's values were names
# of variables after the spreading

?gather
# convert	
# If TRUE will automatically run type.convert() on the key column.
# This is useful if the column names are actually numeric, integer, or logical
?type.convert
# Convert a data object to logical, integer, numeric, complex,
# character or factor as appropriate.

stocks %>% 
  spread(year, return, 
         convert = TRUE) %>% 
  gather("year", "return", `2015`:`2016`,
         convert = TRUE)
# now year is stored as integer

# 2.
# table4a %>% 
#  gather(1999, 2000, key = "year", value = "cases")
# Error in inds_combine(.vars, ind_list) : Position must be between 0 and n


table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases") # number colnames need ``

# 3. 
people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

# people %>% spread(key = key, value = value) 
# Error: Duplicate identifiers for rows (1, 3)

people <- people %>% mutate(id = 1:5)
people %>% spread(key = key, value = value) 

# 4.
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

preg %>% gather(male, female, key = gender, value = n)

# 12.4 separating and uniting
table3 %>% separate(col = rate, into = c("cases", "population"))
table3 %>% separate(col = rate,
                    into = c("cases", "population"),
                    sep = "/") # explicit separator

(table5 <- table3 %>% separate(col = year, into = c("century", "year"), 
                    sep = 2)) # two last characters

table5 %>% unite(col = year,
                 ... = century, year) 

table5 %>% unite(col = year,
                 ... = century, year,
                 sep = "") %>% # get rid of default sep 
  separate(col = rate, into = c("cases", "population"))

# excercises 12.4.3

# 1. 
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"),
           extra = "warn") # default: drop and warn

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"),
           extra = "drop") # drop no warn

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"),
           extra = "merge") # only splits at most length(into) times

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"),
           fill = "warn") # default: warn and fill with NA's from the right

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"),
           fill = "right") # no warn fill from the right 

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"),
           fill = "left") # no warn fill from the left

# 2. 
?unite
# remove	
# If TRUE, remove input columns from output data frame.

# FALSE may be usefull to comfortably check results of separate()/unite() in one data frame

# 3. 
?extract
# with extract() we are able to use regex to "extract" desired values 
# from an input column
# we capture groups, so one input and one output is possible
?separate
# we may use regex or character position
# we capture by this markers
# so it's imposible to make one output column
table3 %>% separate(col = year, 
                    into = "century", # next column has name `NA`
                    sep = 2)

# just one unite method because others have no application


# 12.5 Missing values

# Surprisingly, a value can be missing in one of two possible ways:
#   
#   Explicitly, i.e. flagged with NA.
# Implicitly, i.e. simply not present in the data.
# 
# Let’s illustrate this idea with a very simple data set:
  
(stocks <- tibble(
    year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
    qtr    = c(   1,    2,    3,    4,    2,    3,    4),
    return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
  ))

# The way that a dataset is represented can make implicit values explicit.
# For example, we can make the implicit missing value explicit by putting years in the columns:

(stocks_spread <- stocks %>% spread(year, return))

# when we need to get rid of NA's

stocks_spread %>% gather(year, return, `2015`:`2016`, na.rm = TRUE)
stocks_spread %>% gather(`2015`, `2016`, key = "year", value = "return",
                         na.rm = TRUE) # same result 

# complete() takes a set of columns, and finds all unique combinations.
# It then ensures the original dataset contains all those values, 
# filling in explicit NAs where necessary.

stocks %>% complete(year, qtr) # adds year = 2016, qrt = 1, return = NA

# in some cases missing values indicate that the previous value 
# should be carried forward:

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)

treatment %>% fill(person) # ast observation carried forward


# 12.5.1 Exercises
# 
# 1. Compare and contrast the fill arguments to spread() and complete().
# 
?spread
# fill - if set, missing values will be replaced with this value. 
# applies to both implicit and explicit missings

?complete
# A named list that for each variable supplies a single value 
# to use instead of NA for missing combinations.

# 2. What does the direction argument to fill() do?
# makes fill "down" (default)
# or "up"

treatment %>% fill(person, .direction = "down")
treatment %>% fill(person, .direction = "up")
