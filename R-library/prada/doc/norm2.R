### R code from vignette source 'norm2.Rnw'

###################################################
### code chunk number 1: setup
###################################################
par(mfrow=c(1,1))


###################################################
### code chunk number 2: importData
###################################################
library(prada)
sampdat <- readFCS(system.file("extdata", "fas-Bcl2-plate323-04-04.A01", 
                               package="prada"))
fdat    <- exprs(sampdat)


###################################################
### code chunk number 3: plotsbefore
###################################################
plot(fdat[,"FSC-H"], fdat[,"SSC-H"], pch=20, col="#303030", 
     xlab="FSC", ylab="SSC", main="Scatter plot FSC vs SSC")


###################################################
### code chunk number 4: plotNorm2
###################################################
nfit <- fitNorm2(fdat[,"FSC-H"], fdat[,"SSC-H"], scalefac=2)


###################################################
### code chunk number 5: plotNorm2-1
###################################################
plotNorm2(nfit, selection=TRUE, ellipse=TRUE)


###################################################
### code chunk number 6: plotNorm2-2
###################################################
nfit3 <- fitNorm2(fdat[,"FSC-H"], fdat[,"SSC-H"], scalefac=3)
plotNorm2(nfit3, selection=TRUE, ellipse=TRUE)


###################################################
### code chunk number 7: indexing
###################################################
cleanfdat <- fdat[nfit$sel,]


###################################################
### code chunk number 8: plotafter
###################################################
par(mfrow=c(1,2))
xlim <- range(fdat[,"FL1-H"])
ylim <- range(fdat[,"FL4-H"])
plot(fdat[,"FL1-H"], fdat[,"FL4-H"], pch=20, col="#303030", xlab="FL1", 
     ylab="FL4", main="all data", xlim=xlim, ylim=ylim)
plot(cleanfdat[,"FL1-H"], cleanfdat[,"FL4-H"], pch=20, col="#303030", xlab="FL1", 
     ylab="FL4", main="clean data only", xlim=xlim, ylim=ylim)


###################################################
### code chunk number 9: smoothscatter
###################################################
smoothScatter(fdat[,c("FSC-H", "SSC-H")], nrpoints=50) 


