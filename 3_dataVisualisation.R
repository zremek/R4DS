library(tidyverse)

# http://r4ds.had.co.nz/data-visualisation.html

### check the data
ggplot2::mpg
mpg %>% summary()
mpg %>% str()

table(mpg$manufacturer) %>% sort(decreasing = TRUE) # car's manufacture in descending order

by(data = mpg$model, 
   INDICES = mpg$manufacturer, 
   function(x) sort(table(droplevels(x)), decreasing = TRUE)) # car's model for each manufacturer, desc for each

?mpg
table(mpg$model) %>% length() # 38 different models
table(mpg$trans) %>% sort(decreasing = TRUE) # transmission [skrzynia biegów]


### start plotting!

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

## ggplot template is:
# ggplot(data = <DATA>) + 
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

## exercises
# 1.
ggplot(data = mpg) # an empty plot

# 2. 
dim(mpg) # 234 rows, 11 columns

# 3. mpg$drv is a drivetype: f = front-wheel drive, r = rear wheel drive, 4 = 4wd

# 4. 
ggplot(mpg) +
  geom_point(aes(x = cyl, y = hwy)) # mapping can be diferent for each geom...

ggplot(mpg, aes(x = cyl, y = hwy)) +
  geom_point() +
  geom_jitter() # ...but when you want to map same things to more geoms, put aes() into ggplot()

# 5.
ggplot(mpg) +
  geom_point(aes(x = class, y = drv)) # not useful for categorical data

### adding aesthetics
# colour
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, colour = class))
# size
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, size = class)) #Warning message:
                                                      #Using size for a discrete variable is not advised. 
# transparency - the aplha
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, alpha = class))
# shape
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, shape = class))
        # Warning messages:
        #   1: The shape palette can deal with a maximum of 6 discrete values because more than 6 becomes difficult to
        # discriminate; you have 7. Consider specifying shapes manually if you must have them. 
        # 2: Removed 62 rows containing missing values (geom_point). 

# setting aesthetics properties manually
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy), colour = "blue") # all blue; goes OUTSIDE aes()

## exercises:
# 1. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue")) # "blues" should be outside of aes

# 2.
sapply(mpg, class) %>% table() # count classes
sapply(mpg, class)[sapply(mpg, class) == "character"] # variables class "character" 
sapply(mpg, class)[sapply(mpg, class) != "character"] # variables of other class

# 3. 
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, colour = year)) # colour goes shading, mpg$year is cutted

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, size = cyl)) # size works well with integers

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, shape = cty)) # Error: A continuous variable can not be mapped to shape

# 4. 
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, colour = hwy)) # same variable to more than one aes(), works ok

# 5. stroke aes? - point border
?geom_point

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy), stroke = .5, alpha = .5)

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy), stroke = 5, alpha = .1)

# 6.
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, colour = displ < 5))

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, colour = class == "2seater"))

## facets
# split polt by discrete variable
p <- ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy))

p + 
  facet_wrap(~ class) # facets for split by one discrete variable

p + facet_wrap(~ class, nrow = 2)
p + facet_wrap(~ class, ncol = 2)

p + facet_grid(drv ~ cyl) # facets for split by combination of two discretes

p + facet_grid(. ~ cyl) # one discrete and plots in one row
p + facet_wrap(~ cyl, nrow = 1) # same result

# exercises:
# 1. 
p + facet_wrap(~ year)

p + facet_wrap(~ cty)

ggplot(mpg) + 
  geom_point(aes(x = cyl, y = cty), position = "jitter") +
  facet_wrap(~ displ) # facets work s for numeric variables, but treats each specific value as one level

# 2.
p + facet_grid(drv ~ cyl) # some facets are empty

ggplot(mpg) +
  geom_point(aes(x = drv, y = cyl)) # no cars for: 5 cyl * 4 drv AND 5 cyl r drv AND 4 cyl * drv r

table(mpg$cyl, mpg$drv)

# 3.
p + facet_grid(drv ~ .) # shows each drv level in a row
p + facet_grid(. ~ cyl) # in a column

p + facet_grid(. ~ drv) # in a column
p + facet_grid(cyl ~ .) # row

# 4. 
p + facet_wrap(~ class, nrow = 2) # facets are better than colours for large dataset
                                  # facets are good for lots of discrete levels split
                                  # colours are good for <5 levels, and you see all in one picture

# 5. 
      # facet_wrap wraps 1d sequence of panels (split by one variable) into 2d (still one variable, but rows and cols)
      # facet_grip doesn't have nrow, ncol, because it's 1d for one var, and 2d for two, with cols and rows for each unique level

# 6. 
      # with facet_grpi we put var with more unique vaules in columns, because most comp screens are wider than higher

### 3.6 Geometric objects

# geom is a object that a plot uses to represent data
# so barplot uses geom bar, boxplt uses geom box and so on

ggplot(mpg) +
  geom_smooth(aes(x = displ, y = hwy))

# not every aesthetic works with every geom

ggplot(mpg) +
  geom_smooth(aes(x = displ, y = hwy, size = drv)) # not good idea

ggplot(mpg) +
  geom_smooth(aes(x = displ, y = hwy, linetype = drv, colour = drv)) # nice

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, colour = drv), size = 1, position = "jitter") +
  geom_smooth(aes(x = displ, y = hwy, colour = drv)) # two geoms in one picture

# ggplot2 provides over 30 geoms
# check: https://www.ggplot2-exts.org
# cheatsheet: http://rstudio.com/cheatsheets

ggplot(mpg) +
  geom_smooth(aes(x = displ, y = hwy, group = drv)) # no legend by default

ggplot(mpg) +
  geom_smooth(aes(x = displ, y = hwy, colour = drv)) # shows legend

ggplot(mpg) +
  geom_smooth(aes(x = displ, y = hwy, colour = drv), 
              show.legend = FALSE) # no legend by hand


## two geoms on one plot

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  geom_smooth(aes(x = displ, y = hwy)) # aes() replication

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth() # same plot, no code duplication

# specify aes for each geom

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth()

# specify data for each geom

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = class)) +
  geom_smooth(data = dplyr::filter(mpg, class == "subcompact"), se = FALSE) # smooth just for subcompacts
                                                                            # no standar errors visible
## exercises
# 1. how to do a linechart?

ggplot(mpg, aes(cty, hwy, colour = drv)) +
  geom_line()

# 2. 
ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

# 6. reproduce graphs you see
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(colour = "blue", se = FALSE)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(aes(group = drv), colour = "blue", se = FALSE )

ggplot(mpg, aes(displ, hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(colour = "blue", se = FALSE)

ggplot(mpg, aes(displ, hwy)) +
  geom_smooth(aes(linetype = drv), se = FALSE, colour = "blue") +
  geom_point(aes(colour = drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(fill = drv), stroke = 3, shape = 21, colour = "white", size = 3)


#### 3.7 statistical transformation

# barchart is quite simple, but it calculates sth for plot - doesn't show raw data like a scatter plot

ggplot2::diamonds %>% head()
dim(diamonds)
str(diamonds)
summary(diamonds)

sapply(diamonds[,c(1,5:10)], hist) # works, but crappy names :) I can't fix it

# how to make a barchart?

ggplot(diamonds) +
  geom_bar(aes(x = cut))

# y axis displays count, but there is no "count" variable - it's calculated for plot
# some calculations are done for 
  #bars, histograms, freq polygons (bin and count), 
  #smoothers (model fir) 
  #and boxplots (summary statistics)

# the algorithm used to calculate sth from data for a graph is called a stat
# for bar plot it's stat_count()

?geom_bar
# "geom_bar uses stat_count by default: it counts the number of cases at each x position"

# plot above can be done using stat_count instead of geom_bar

ggplot(data = diamonds) +
  stat_count(aes(x = cut))
# works because every geom has a default stat and every stat has a default geom
# so we can typically use geoms without worring about underlying stats transformation;
  # but sometimes we need to use stats explicit:

  # so plot raw vaules using bars will be

demo <- tribble(
  ~cut, ~freq,
  "Fair", 1610,
  "Good", 4906,
  "Very Good", 12082,
  "Premium", 13791,
  "Ideal", 21551
)

ggplot(demo) +
  geom_bar(aes(x = cut, y = freq), stat = "identity")

ggplot(demo) +
  geom_col(aes(x = cut, y = freq)) # geom_col has stat "identity" by default 

  # bar chart of proportion:

ggplot(data = diamonds) +
  geom_bar(aes(x = cut, y = ..prop.., group = 1))

  # sometimes we want to draw greater attention to transformations in our code:

ggplot(data = diamonds) +
  stat_summary(aes(x = cut, y = depth), 
               fun.ymin = min,
               fun.ymax = max,
               fun.y = median)

# exercises:
# 1. revrite previous stat_summary plot using geom
?stat_summary
?geom_pointrange


    # example from help

df <- data.frame(
  trt = factor(c(1, 1, 2, 2)),
  resp = c(1, 5, 3, 4),
  group = factor(c(1, 2, 1, 2)),
  upper = c(1.1, 5.3, 3.3, 4.2),
  lower = c(0.8, 4.6, 2.4, 3.6)
)

plot <- ggplot(df, aes(trt, resp, colour = group))
plot + geom_linerange(aes(ymin = lower, ymax = upper))
plot + geom_pointrange(aes(ymin = lower, ymax = upper))
plot + geom_crossbar(aes(ymin = lower, ymax = upper), width = 0.2)
plot + geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.2)

df

ggplot(df, aes(trt, resp)) + geom_pointrange(aes(ymax = resp, ymin = resp))
  
  ################# my solution

diamenty_min <- tapply(diamonds$depth, INDEX = diamonds$cut, min)
diamenty_me <- tapply(diamonds$depth, INDEX = diamonds$cut, median)
diamenty_max <- tapply(diamonds$depth, INDEX = diamonds$cut, max)

diamenty <- cbind.data.frame(diamenty_min, diamenty_me, diamenty_max) # we really have to make stats before plot!

ggplot(diamenty, aes(x = as.factor(row.names(diamenty)), y = diamenty_me)) +
  geom_pointrange(aes(ymin = diamenty_min, ymax = diamenty_max)) # works well

ggplot(diamenty, aes(x = as.factor(row.names(diamenty)), y = diamenty_me)) +
  geom_pointrange(aes(ymin = diamenty_min, ymax = diamenty_max)) +
  stat_summary(data = diamonds, aes(x = cut, y = depth), 
             fun.ymin = min,
             fun.ymax = max,
             fun.y = median, 
             colour = "red",
             alpha = 0.2,
             position = "jitter") # compare if stat_summary works excacly like mine geom_pointrange

ggplot(diamonds, aes(x = cut, y = depth)) +
  geom_pointrange(stat = "summary",
                  fun.y = median,
                  fun.ymin = min,
                  fun.ymax = max) # errr... much easier :D

# thx to: https://jrnold.github.io/e4qf/visualize.html#statistical-transformations


##################
# for fun

ggplot(diamonds) +
  geom_point(aes(x = cut, y = depth), position = "jitter", alpha = 0.3)


head(diamonds)

ggplot(diamonds) +
  geom_boxplot(aes(x = cut, y = depth)) +
  stat_summary(aes(x = cut, y = depth), 
               fun.ymin = min,
               fun.ymax = max,
               fun.y = median, 
               colour = "red")

# 2.
  # geom_col has default "position" stat; geom_bar has default "count" stat

# 3. similar names
# 4. 
?stat_smooth

## computed variables are:
  # y: predicted value
  # ymin: lower pointwise confidence interval around the mean
  # ymax: higher pointwise CI around the mean
  # se: standard error

## parameters to control geom_smooth() behaviour are:
  # method: smoothing function, like "lm", "glm", "gam","loess"
    # if n < 1000 the default is "loess", else "gam"
  # formula: formula to use in smoothing function
  # se: should CI be displayed? TRUE / FALSE
  # n: number of points to evaluate smoother at
  # span: controls the amount of smoothing for "loess"
    # small number for wiggler lines, large for smoother
  # fullrange: should the fit span the full range of plot or just the data
  # level: CI level, 0.95 default
  # method.args: list of additional args passed to the function defined by method

# 5. what is wrong?
ggplot(diamonds) +
  geom_bar(aes(x = cut, y = ..prop..))

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color, y = ..prop..)) # I don't know how to fix it yet

ggplot(diamonds) +
  geom_bar(aes(x = cut, y = ..prop.., group = 1)) # group = 1 makes stat compute props well (props sum to 1)

ggplot(diamonds) +
  geom_bar(aes(x = cut, y = ..prop.., group = 475959495)) # but it still works... don't know why yet

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color, y = ..prop.., group = 1))

ggplot(diamonds) +
  geom_bar(aes(x = cut, group = 1))

ggplot(diamonds) +
  geom_bar(aes(x = cut))

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color))

ggplot(diamonds) +
  geom_bar(aes(x = color, fill = cut, y = ..prop..))

### 3.8 position adjustment

ggplot(diamonds) +
  geom_bar(aes(x = cut, colour = cut))

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = cut))

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = cut, y = ..prop.., group = 1)) # fill doesn't work

# stacked = spiętrzony
ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = clarity)) # it's default position adjustment "stack"

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = clarity), position = position_stack()) # the same

 # position = "identity"
# will place each object exactly where it falls in the context of graph; it overlaps bars

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = clarity), alpha = 0.5, position = "identity") # one bar on the other - bad

ggplot(diamonds) +
  geom_bar(aes(x = cut, colour = clarity), fill = NA, position = "identity") # same situation - hard do see anything
            # but identity position is good for points - it's default for geom_point

  # position = "fill" makes stacked percent bar plot 
  # good for comparing proportions across groups
ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = clarity), position = "fill")

  # position = "dodge" makes grouped bar plot
  # good for comparing individual values
ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = clarity), position = "dodge")

# check help for each position
###
?position_dodge
ggplot(diamonds, aes(price, fill = cut)) +
  geom_histogram(position="dodge")

ggplot(diamonds, aes(price, colour = cut)) +
  geom_freqpoly()

df <- data.frame(x = c("a","a","b","b"), y = 2:5, g = rep(1:2, 2))
pr <- ggplot(df, aes(x, y, group = g)) +
  geom_col(position = "dodge", fill = "grey50", colour = "black")
pr + geom_linerange(
  aes(ymin = y - 1, ymax = y + 1),
  position = position_dodge(width = 1)
)
### "fill" stacks bars and standardises each stack to have constant height.
?position_fill
ggplot(mtcars, aes(factor(cyl), fill = factor(vs))) +
  geom_bar() # so it's just stack

ggplot(mtcars, aes(factor(cyl), fill = factor(vs))) +
  geom_bar(position = "fill") # and it's 100% stack - fill

ggplot(diamonds, aes(price, fill = cut)) +
  geom_histogram(binwidth = 500) # stack

ggplot(diamonds, aes(price, fill = cut)) + 
  geom_histogram(binwidth = 500, position = "fill") # fill

# Stacking is also useful for time series
series <- data.frame(
  time = c(rep(1, 4),rep(2, 4), rep(3, 4), rep(4, 4)),
  type = rep(c('a', 'b', 'c', 'd'), 4),
  value = rpois(16, 10)
)
ggplot(series, aes(time, value)) +
  geom_area(aes(fill = type))

###
?position_identity # don't adjust position

?position_jitter # add noise to avoid overplotting

?position_stack # stack bars on top of each other

# exercises
# 1. wht's wrong
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point(position = "jitter") # fix overlapping

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() +
  geom_jitter() # other way to code the same

# 2. what parametrs of jitter controls amount of jittering?
  # width and height

# 3. geom_jitter vs. geom_count
?geom_count

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() +
  geom_count() # counts overlaping points

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() +
  geom_jitter() +
  geom_count()

### 3.9 coordinate systems

# most complicated part of ggplot2
# default is cartesian

# coord_flip() switches axes x and y

ggplot(mpg) +
  geom_boxplot(aes(class, hwy)) +
  coord_flip()

    ## order asc / desc with forcats package
library(forcats)

ggplot(mpg) +
  geom_boxplot(aes(forcats::fct_reorder(f = class, x = hwy, fun = "median"), hwy)) + # asc 
  coord_flip()

ggplot(mpg) +
  geom_boxplot(aes(forcats::fct_reorder(f = class, x = hwy, fun = "median", .desc = TRUE), hwy)) + # desc 
  coord_flip()

ggplot(mpg) +
  geom_boxplot(aes(forcats::fct_reorder(f = class, x = hwy, fun = "sd", .desc = TRUE), hwy)) + # ordered by standard deviation
  coord_flip()

ggplot(mpg) +
  geom_boxplot(aes(forcats::fct_reorder(f = class, x = hwy, fun = "mead", .desc = TRUE), hwy)) + # o by mean
  coord_flip()

# coord_quickmap() sets the aspect ratio correctly for maps - for spatial data
nz <- map_data("nz") # New Zeland?
View(nz)

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") # wrong ratio - default cartesian

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap() # correct ratio

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = region), colour = "black") +
  coord_quickmap() # fill by region - things excluding north island ans south island are barely visible :)

# coord_polar

bar <- ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = cut),
           show.legend = FALSE,
           width = 1) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

# excercises 3.9.1
# 1. turn stacked barchart into pie
ggplot(diamonds) +
  geom_bar(aes(x = color, fill = cut)) +
  coord_polar() # nice, shows to factor variables but not a simple pie

ggplot(diamonds) +
  geom_bar(aes(x = factor(1), fill = cut), width = 1) + # artificial var factor(1) made to drop all records into one category
  coord_polar() # still not a pie, it's a bullseve chart

ggplot(diamonds) +
  geom_bar(aes(x = factor(1), fill = cut), width = 1) + 
  coord_polar(theta = "y") # true PIE :) theta = "y" maps count to the angle

ggplot(diamonds) +
  geom_bar(aes(x = factor(1), fill = cut), width = 1, position = "fill") + # fill to 100% stacked bar
  coord_polar(theta = "y") # true PIE :) theta = "y" maps fraction to the angle

  ## different way to show two factor variables
ggplot(diamonds) +
  geom_bar(aes(x = color, fill = cut), position = "fill") +
  coord_polar(theta = "y") # multi stacked donut chart :D 


View(diamonds)

graphics::plot(diamonds$color)

# 2. 
?labs()

p <- ggplot(mtcars, aes(mpg, wt, colour = cyl)) + geom_point()
p + labs(colour = "Cylinders")
p + labs(x = "New x label")

# The plot title appears at the top-left, with the subtitle
# display in smaller text underneath it
p + labs(title = "New plot title")
p + labs(title = "New plot title", subtitle = "A subtitle")

# The caption appears in the bottom-right, and is often used for
# sources, notes or copyright
p + labs(caption = "(based on data from ...)")

MSDC <- ggplot(diamonds) +
  geom_bar(aes(x = color, fill = cut), position = "fill") +
  coord_polar(theta = "y") # multi stacked donut chart :D 

MSDC + labs(title = "Diamonds' color by cut",
            subtitle = "each color's donut is 100% stacked",
            y = "",
            caption = "created by REMOL form ggplot2 'diamonds' data")

# 3.
?coord_map # do not preserve straight lines
?coord_quickmap # makes aproximation for straight lines; good for smaller areas

# 4.
View(mpg)
?mpg

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() + # adds straight reference line
  coord_fixed() # default ratio = 1, whitch means that one unit on x is the same lenght as 1 unit on y axis

  # graph showes positive linear relationship between cty and hwy

## 3.10. The layered grammar of graphics

### the ultimate ggplot2 code template:

# ggplot(data = <DATA>) +
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>,
#     position = <POSITION>) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>

## the seven parameters above shown in < > compose the grammar of graphics,
# so any plot can be described as combination of:
  #1. data
  #2. geom
  #3. mappings
  #4. stats
  #5. position
  #6. coordinates
  #7. facets

ggplot(diamonds) +
  stat_count(aes(x = cut, fill = cut))

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color))

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color), position = "dodge")

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color), position = "fill")

ggplot(diamonds) +
  geom_bar(aes(x = cut, y = ..prop.., group = 1)) # on y axis prop of all records

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color, y = ..count.. / sum(..count..))) # same prop on y

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color, y = ..count.. / sum(..count..)), 
           position = "dodge") # same prop on y - prop of all

# want to see % instead of 0.sth ?
library(scales)

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color, y = ..count.. / sum(..count..))) +
  scale_y_continuous(labels = scales::percent)

ggplot(diamonds) +
  geom_bar(aes(x = cut, fill = color %in% c("G", "E") , y = ..count.. / sum(..count..)), 
           position = "dodge",
           colour = "white") +
  scale_y_continuous(labels = scales::percent)
