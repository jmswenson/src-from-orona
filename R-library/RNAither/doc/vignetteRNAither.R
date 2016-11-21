### R code from vignette source 'vignetteRNAither.Rnw'

###################################################
### code chunk number 1: setup1
###################################################
library("RNAither")


###################################################
### code chunk number 2: vignetteRNAither.Rnw:80-127
###################################################
#gene names
plateLayout1 <- c("test1", "empty", "test3", "test4", "test5", 
"test6", "test7", "empty", "test9", "test10", "test11", "test12")

plateLayout2 <- c("test1", "test2", "test3", "test4", "test5", 
"test6", "test7", "test8", "test9", "test10", "test11", "test12")

plateLayout <- cbind(plateLayout1, plateLayout2)

emptyWells <- list(c(2, 8), NA_integer_)
#the first plate has two empty wells at position 2 and 8,
#the second plate does not have any empty wells

poorWells <- NA_integer_
#no wells of poor quality

controlCoordsOutput <- list(list(NA_integer_, NA_integer_), list(NA_integer_, c(9,10)))
#the first plate does not have any control siRNAs,
#the second plate has two negative controls at position 9 and 10

backgroundValOutput<-NA_integer_
#no background signal intensities available

sigPlate1<-c(2578, NA_integer_, 3784, 3784, 2578, 5555, 5555, NA_integer_, 8154, 2578, 3784, 2578)
sigPlate2<-c(8154, 3784, 5555, 3784, 11969, 2578, 1196, 5555, 17568, 2578, 5555, 2578)
#the signal intensities on the plates

meanSignalOutput<-list(sigPlate1, sigPlate2)

SDmeansignal<-NA_integer_
#no standard deviation available

objnumOutput<-NA_integer_
#no cell count available

cellnumOutput<-NA_integer_

generateDatasetFile("First test screen", "RNAi in virus-infected cells", 
NA_character_, "testscreen_output.txt", plateLayout, plateLayout, 3, 4, 
1, emptyWells, poorWells, controlCoordsOutput, backgroundValOutput, 
meanSignalOutput, SDmeansignal, objnumOutput, cellnumOutput)

#load the dataset into R:
header<-readLines("testscreen_output.txt",3)
dataset<-read.table("testscreen_output.txt", skip=3, colClasses=c(NA, 
NA, NA, NA, "factor", NA, NA, NA, NA, NA, NA, NA, NA, NA), 
stringsAsFactors=FALSE)


###################################################
### code chunk number 3: vignetteRNAither.Rnw:132-134
###################################################
data(exampleDataset, package="RNAither")
doubledataset <- joinDatasets(list(dataset, dataset))


###################################################
### code chunk number 4: vignetteRNAither.Rnw:139-147
###################################################
data(exampleHeader, package="RNAither")
data(exampleDataset, package="RNAither")
saveDataset(header, dataset, "save_testfile1.txt")

header[[1]] <- "external_experiment_name,Test screen"
header[[2]] <- "comments,contains twice Screen Nb. 1"

joinDatasetFiles(list( "save_testfile1.txt", "save_testfile1.txt"), 3, header, "concatenated_testfile.txt")


