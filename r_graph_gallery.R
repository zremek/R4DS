# http://www.r-graph-gallery.com/48-grouped-barplot-with-ggplot2/

# create a dataset
specie=c(rep("sorgho" , 3) , rep("poacee" , 3) , rep("banana" , 3) , rep("triticum" , 3) )
condition=rep(c("normal" , "stress" , "Nitrogen") , 4)
value=abs(rnorm(12 , 0 , 15))
data=data.frame(specie,condition,value)

data

# Grouped
gr <- ggplot(data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar(position="dodge", stat="identity") +
  geom_text(aes(label = round(value, 1)), vjust = 0, position = position_dodge(width = 1))

# Stacked
st <- ggplot(data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar( stat="identity") +
  geom_text(aes(label = round(value, 1)), position = position_stack(vjust = 0.5))


# Stacked Percent
st_pct <- ggplot(data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar( stat="identity", position="fill") +
  geom_text(aes(label = round(value, 1)), position = position_fill(vjust = 0.5))

require(gridExtra)
grid.arrange(gr, st, st_pct  + coord_flip(), ncol = 2)
