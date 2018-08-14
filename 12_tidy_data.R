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