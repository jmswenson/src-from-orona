### R code from vignette source 'prada2cellHTS.Rnw'

###################################################
### code chunk number 1: prepare
###################################################
library("cellHTS")


###################################################
### code chunk number 2: readPlateData
###################################################
experimentName = "ApoptosisScreen"
dataPath = system.file("extdata", package = "prada")
x = readPlateData("Platelist.txt", name = experimentName, 
                  path = dataPath, verbose = FALSE)
x


###################################################
### code chunk number 3: configure
###################################################
confFile = file.path(dataPath, "Plateconf.txt")
logFile = file.path(dataPath, "Screenlog.txt")
descripFile = file.path(dataPath, "Description.txt")
x = configure(x, confFile, logFile, descripFile)


###################################################
### code chunk number 4: normalize
###################################################
x$xnorm <- -log10(x$xraw)
x$state["normalized"] <- TRUE


###################################################
### code chunk number 5: report (eval = FALSE)
###################################################
## geneIDFile = file.path(dataPath, "GeneIDs.txt")
## x = annotate(x, geneIDFile)
## writeReport(x, force = TRUE, plotPlateArgs = list(xrange = c(0.2,
##     1.5), xcol=c("white", "red")), 
##     imageScreenArgs = list(zrange = c(-2, 6.5), ar = 1))


