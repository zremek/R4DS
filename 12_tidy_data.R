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
