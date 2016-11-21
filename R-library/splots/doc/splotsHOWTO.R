### R code from vignette source 'splotsHOWTO.Rnw'

###################################################
### code chunk number 1: exampledata
###################################################
library("splots")
screen = lapply(1:12, function(i) cumsum(rnorm(384)))
names(screen) = paste("plate", LETTERS[seq(along=screen)])


###################################################
### code chunk number 2: splotsHOWTO.Rnw:36-37
###################################################
plotScreen(screen, ncol=3)


###################################################
### code chunk number 3: splotsHOWTO.Rnw:44-45
###################################################
plotScreen(screen, ncol=2, do.legend=FALSE)


###################################################
### code chunk number 4: splotsHOWTO.Rnw:52-55
###################################################
plotScreen(screen, ncol=4, fill=c("white", "darkblue"), 
           main="Example data", 
           legend.label=expression(bar(x) == sum(x[i], i==1, n)))


###################################################
### code chunk number 5: splotsHOWTO.Rnw:62-66
###################################################
for(i in seq(along=screen))
  screen[[i]][sample(384, 5)] = NA
plotScreen(screen, ncol=4, do.names=FALSE, 
           main="Example data", legend.label="Legend label")


###################################################
### code chunk number 6: sessionInfo
###################################################
toLatex(sessionInfo())


