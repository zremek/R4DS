# 4.1 coding basics

# assignments

object_name <- "value"

### object name gest value

# the famous <- is hard to type, so use Alt + <minus sign> shortcut :D
# giveyoureyesabreak and use spaces

# 4.2 naming objects:

hadley_uses_snake_case <- 1
otherPeopleUseCamelCase <- 2
some.use.periods <- 3
aFew_renounceCONVENTIONS <- 4

some.use.periods
some.2 <- 242
some.3 <- 4534

# 4.3 calling functions

seq(1, 10)

seq(1, 10, length.out = 5)
(sekw <- seq(1, 10, length.out = 50))
sekw[2] - sekw[1]
(sekw[44] + (sekw[2] - sekw[1])) %>% round(., 4) == sekw[45] %>% round(., 4)
round((sekw[2] - sekw[1]), 4) == round((sekw[12] - sekw[11]), 4)

sekw[3] - sekw[2] == sekw[49] - sekw[48] # false
near(sekw[3] - sekw[2], sekw[49] - sekw[48]) #true, because dplyr::near() got bulid-in kind of rounding 

############################
#  training your brain to notice even the tiniest difference will pay off when programming
############################

## exercises
# 2. find typos 
library(tidyverse)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)

filter(diamonds, carat > 3)

# 3.
# Alt + Shift + K shortcut shows shortcuts help :)