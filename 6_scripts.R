# The script editor is a great place to put code you care about. 
# Keep experimenting in the console, but once you have written code
# that works and does what you want, put it in the script editor. 
# RStudio will automatically save the contents of the editor 
# when you quit RStudio, and will automatically load it when you re-open.
# Nevertheless, it’s a good idea to save your scripts regularly 
# and to back them up.

# Ctrl + Enter runs current expression

# Ctrl + Shift + S runs the whole script

### WARNING!
### using library() on the begining of the script is recomended
### never use install.packages() nor setwd() in shared scripts
### Hadley says:
      # It’s very antisocial to change settings 
      # on someone else’s computer!

# 6.2 RStudio diagnostics
# The script editor will also highlight syntax errors 
# with a red squiggly line and a cross in the sidebar:

x y <- 2

# warning problems

3 == NA

# 6.3 practice

  ##  go to https://twitter.com/rstudiotips 
  ## and find one tip that looks interesting. Practice using it!

  # Shift + Ctrl + 2 == full window console
  # Shift + Ctrl + 1 == full window script editor
  # this works with [1-9] digits for diferent focus
  # Ctrl + Shift + Alt + 0 == show all four standard panes...
  # ... but the focus shortcuts can be used instead
    # so you see 4 panes
    # press Shift + Ctrl + 2 == full window console
    # Shift + Ctrl + 2 again == 4 panes

  ## What other common mistakes will RStudio diagnostics report? 
  ## Read https://support.rstudio.com/hc/en-us/articles/205753617-Code-Diagnostics
  ## to find out.
  
  # intresting: Provide R style diagnostics (e.g. whitespace)
  # R styleguides:
    # Google - https://google.github.io/styleguide/Rguide.xml
    # Hadley - http://adv-r.had.co.nz/Style.html
  