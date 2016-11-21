### R code from vignette source 'ChromBand.Rnw'

###################################################
### code chunk number 1: setup1
###################################################
library("Category")
library("ALL")
library("hgu95av2.db")
library("annotate")
library("genefilter")
library("SNPchip")
library("geneplotter")
library("limma")
library("lattice")
library("graph")


###################################################
### code chunk number 2: Setup2
###################################################
options(width=80)


## FIXME: this needs to go somewhere, not sure where
##        it is a _slightly_ modified version from SNPchip
##  RG asks if the slight mod might not be taken up  by the SNPchip
##        folks? Otherwise, geneplotter is the obvious place

plotCytoband2 <- function(chromosome,
                         cytoband,
                         xlim,
                         xaxs="r",
                         new=TRUE,
                         label.cytoband=TRUE,
                         cex.axis=1,
                         outer=FALSE,
                         ...){
    def.par <- par(no.readonly=TRUE, mar=c(4.1, 0.1, 3.1, 2.1))
    on.exit(def.par)
    if(missing(cytoband)) data(cytoband, package="SNPchip", envir=environment())
    if(missing(chromosome)){
        if(length(unique(cytoband[, "chrom"])) > 1) stop("Must specify chromosome")
    }
    if(length(unique(cytoband$chrom)) > 1){
        cytoband <- cytoband[cytoband[, "chrom"] == chromosome, ]
    }
    rownames(cytoband) <- as.character(cytoband[, "name"])
    if(missing(xlim))
        xlim <- c(0, SNPchip:::chromosomeSize(unique(cytoband$chrom)))
    cytoband_p <- cytoband[grep("^p", rownames(cytoband), value=TRUE), ]
    cytoband_q <- cytoband[grep("^q", rownames(cytoband), value=TRUE), ]

    p.bands <- nrow(cytoband_p)
    cut.left  <- c()
    cut.right <- c()
    ##  1st  band of arm or 1st  band after  "stalk"
    ##  last band of arm or last band before "stalk"
    for (i in 1:nrow(cytoband)) {
        if (i == 1) { cut.left[i] <- TRUE; cut.right[i] <- FALSE} else
        if (i == p.bands) { cut.left[i] <- FALSE; cut.right[i] <- TRUE} else
        if (i == (p.bands+1)) { cut.left[i] <- TRUE; cut.right[i] <- FALSE} else
        if (i == nrow(cytoband)) { cut.left[i] <- FALSE; cut.right[i] <- TRUE} else{
            cut.left[i] <- FALSE; cut.right[i] <- FALSE
        }
    }
    for (i in 1:nrow(cytoband)) {
        if (as.character(cytoband[i, "gieStain"]) == "stalk") {
            cut.right[i-1] <- TRUE
            cut.left[i] <- NA
            cut.right[i] <- NA
            cut.left[i+1] <- TRUE
        }
    }
    ##When plotting subregions of a chromosome, this prevents the cytobands from extending beyond the subsetted object
    ##exclude cytobands that end before the minimum plotting limits
    include <- cytoband[, "chromEnd"] > xlim[1] & cytoband[, "chromStart"] < xlim[2]            
    cytoband <- cytoband[include, ]
    cut.left <- cut.left[include]
    cut.right <- cut.right[include]
    if(new){
        plot(c(0, cytoband[nrow(cytoband), "chromEnd"]),
             c(0, 2),
             xlim=xlim,
             type="n",
             xlab="",
             ylab="",
             axes=FALSE,
             xaxs=xaxs,
             ...)
    }
    for (i in 1:nrow(cytoband)) {
        start <- cytoband[i, "chromStart"]
        last   <- cytoband[i, "chromEnd"]
        delta = (last-start)/4
        getStain <- function(stain){
            switch(stain,
                   gneg="grey100",
                   gpos25="grey90",
                   gpos50="grey70",
                   gpos75="grey40",
                   gpos100="grey0",
                   gvar="grey100",
                   stalk="brown3",
                   acen="brown4",
                   "white")
        }
        color <- getStain(as.character(cytoband[i, "gieStain"]))
        if (is.na(cut.left[i]) & is.na(cut.right[i])) {
            ## this is a "stalk", do not draw box. Draw two vertical lines instead
            delta <- (last-start)/3
            lines(c(start+delta, start+delta), c(0,2), col=color)
            lines(c(last-delta, last-delta), c(0,2), col=color)
        } else if (cut.left[i] & cut.right[i]) {      # cut both lasts
            polygon(c(start, start+delta, last-delta, last, last, last-delta, start+delta, start),
                    c(0.3, 0, 0, 0.3, 1.7, 2, 2, 1.7), col=color)
        } else if (cut.left[i]) {              # cut left last only
            polygon(c(start, start+delta, last, last, start+delta, start),
                    c(0.3, 0, 0, 2, 2, 1.7), col=color)
        } else if (cut.right[i]) {             # cut right last only
            polygon(c(start, last-delta, last, last, last-delta, start),
                    c(0, 0, 0.3, 1.7, 2, 2),col=color)
        } else {
            polygon(c(start, last, last, start),
                    c(0, 0, 2, 2), col=color)
        }
    }
    my.x <- (cytoband$chromStart+cytoband$chromEnd)/2
    if(label.cytoband){
        axis(1, at=my.x,
             labels=rownames(cytoband),
             outer=outer,
             cex.axis=cex.axis,
             line=1, las=3, tick=FALSE)
        axis(1, at=cytoband$chromStart,
             outer=outer,
             cex.axis=cex.axis,
             line=1, las=3, label=FALSE)

    }
}

## inducedSubGraph <- function(n, g) {
##     inducedNodes <- unlist(lapply(acc(g, n), names))
##     inducedNodes <- unique(c(n, inducedNodes))
##     subGraph(inducedNodes, g)
## }

## FIXME: where doe these belong? Should they go in a package? 

## sortBands <- function(bands) {
##     chrs <- sub("([^pq]+).*$", "\\1", bands)
##     xyIdx <- match(c("X", "Y"), chrs, 0)
##     xy <- NULL
##     if (any(xyIdx)) {
##         chrs <- chrs[-xyIdx]
##         xy <- bands[xyIdx]
##         df <- bands[-xyIdx]
##     }
##     ord <- order(as.integer(chrs), bands)
##     bands <- bands[ord]
##     if (!is.null(xy))
##       bands <- c(bands, xy)
##     bands
## }


## Note: Seth's old code had assumed that eset would (1) only have
## the genes that pass the t-test p-value threshold and (2) have 
## gene symbols as featureNames().  (1) seems unreasonable, and we 
## decided to include all genes. (2) seems like a convenience to 
## have nice strip labels; we will do this another way.

## subsetByBand <- function(eset, ct, band) {
##     ## eset - ExpressionSet (featureNames assumed to be probe id)
##     ## ct   - ChrBandTree object
##     ## band - String giving the desired band
##     ##
##     ## RETURN: a new ExpressionSet with only those genes found in the
##     ## specified band.

##     ##     syms <- unlist(mget(featureNames(pvalFiltered), symbolMap))
##     ##     entrez2sym <- syms
##     ##     names(entrez2sym) <- selectedEntrezIds
##     ##     featureNames(pvalFiltered) <- syms
    
##     egIDs <- unlist(nodeData(ct@toChildGraph, n=band, 
##                              attr="geneIds"), use.names=FALSE)
##     wantedProbes <- affyUniverse[as.character(egIDs)]
##     ## print(wantedProbes)
##     ## FIXME: shouldn't get any NA's... should investigate
##     ##     wantedSyms <- wantedSyms[!is.na(wantedSyms)]
##     ##     tmpSet <- eset[wantedSyms, ]
##     ##     tmpSet
##     eset[intersect(wantedProbes, featureNames(eset)), ]
## }


## gseaTstatStripplot <- function(bands, g, ..., include.all = FALSE)
## {
##     ## hack to get all top-level stuff. FIXME: more robust solution
##     chroms <- c(1:22, "X", "Y")
##     chromArms <- c(paste(chroms, "p", sep=""),
##                    paste(chroms, "q", sep=""))

##     egid <- lapply(nodeData(g, bands), "[[", "geneIds")
##     affyid <-
##         lapply(egid,
##                function(x) {
##                    affyUniverse[as.character(x)]
##                })
##     if (include.all)
##     {
##         affyid$All <- 
##             affyUniverse[unique(unlist(lapply(nodeData(g)[chromArms], "[[", "geneIds")))]
##     }
##     tdf <- 
##         do.call(make.groups,
##                 lapply(affyid,
##                        function(x) {
##                            ttests[x, "statistic"]
##                        }))
##     stripplot(which ~ data, tdf, jitter = TRUE,
##               ...)
## }

##


###################################################
### code chunk number 3: chr12ideogram
###################################################
data(cytoband, package="SNPchip")
cyt2 <- cytoband
cyt2$gieStain <- "foo"
c12p12_idx <- intersect(grep("^q21", cyt2$name),
                        which(cyt2$chrom == "12"))
cyt2[c12p12_idx, "gieStain"] <- rep(c("gpos50", "gpos75"),
                                    length=length(c12p12_idx))
plotCytoband2(chromosome="12", cyt2, outer=FALSE,
              cex.axis=0.6,
              main="Human chromosome 12")


###################################################
### code chunk number 4: bcrAblOrNegSubset
###################################################
data(ALL, package="ALL")

subsetType <- "BCR/ABL"
Bcell <- grep("^B", as.character(ALL$BT))
bcrAblOrNegIdx <- which(as.character(ALL$mol.biol) %in% c("NEG", subsetType))

bcrAblOrNeg <- ALL[, intersect(Bcell, bcrAblOrNegIdx)]
bcrAblOrNeg$mol.biol <- factor(bcrAblOrNeg$mol.biol)


###################################################
### code chunk number 5: annMaps
###################################################
annType <- c("db", "env")
entrezMap <- getAnnMap("ENTREZID", annotation(bcrAblOrNeg),
                       type=annType, load=TRUE)
symbolMap <- getAnnMap("SYMBOL", annotation(bcrAblOrNeg),
                       type=annType, load=TRUE)
bandMap <- getAnnMap("MAP", annotation(bcrAblOrNeg),
                     type=annType, load=TRUE)


###################################################
### code chunk number 6: nsFiltering
###################################################
filterAns <- nsFilter(bcrAblOrNeg,
                      require.entrez = TRUE, 
                      remove.dupEntrez = TRUE, 
                      var.func = IQR, var.cutoff = 0.5)
nsFiltered <- filterAns$eset


###################################################
### code chunk number 7: ChromBand.Rnw:410-415
###################################################
hasSYM <- sapply(mget(featureNames(nsFiltered), symbolMap, ifnotfound=NA),
                 function(x) length(x) > 0 && !is.na(x[1]))
hasMAP <- sapply(mget(featureNames(nsFiltered), bandMap, ifnotfound=NA),
                 function(x) length(x) > 0 && !is.na(x[1]))
nsFiltered <- nsFiltered[hasSYM & hasMAP, ]


###################################################
### code chunk number 8: defineGeneUniverse
###################################################
affyUniverse <- featureNames(nsFiltered)
entrezUniverse <- unlist(mget(affyUniverse, entrezMap))
names(affyUniverse) <- entrezUniverse
if (any(duplicated(entrezUniverse)))
    stop("error in gene universe: can't have duplicate Entrez Gene Ids")


###################################################
### code chunk number 9: parametric1
###################################################
design <- model.matrix(~ 0 + nsFiltered$mol.biol)
colnames(design) <- c("BCR/ABL", "NEG")
contr <- c(1, -1) ## NOTE: we thus have BCR/ABL w.r.t NEG
fm1 <- lmFit(nsFiltered, design)
fm2 <- contrasts.fit(fm1, contr)
fm3 <- eBayes(fm2)
ttestLimma <- topTable(fm3, number = nrow(fm3), adjust.method = "none")
rownames(ttestLimma) <- as.character(ttestLimma$ID)
ttestLimma <- ttestLimma[featureNames(nsFiltered), ]

tstats <- ttestLimma$t
names(tstats) <- entrezUniverse[rownames(ttestLimma)]
##


###################################################
### code chunk number 10: selectedSubset
###################################################
ttestCutoff <- 0.01
smPV  <- ttestLimma$P.Value < ttestCutoff
pvalFiltered <- nsFiltered[smPV, ]
selectedEntrezIds <- unlist(mget(featureNames(pvalFiltered), entrezMap))
##


###################################################
### code chunk number 11: ChromBand.Rnw:621-637
###################################################

chrSortOrder <- function(df) {
    chrs <- sub("([^pq]+).*$", "\\1", rownames(df))
    xyIdx <- chrs %in% c("X", "Y")
    xydf <- NULL
    if (any(xyIdx)) {
        chrs <- chrs[!xyIdx]
        xydf <- df[xyIdx, ]
        df <- df[!xyIdx, ]
    }
    ord <- order(as.integer(chrs), rownames(df))
    df <- df[ord, ]
    if (!is.null(xydf))
      df <- rbind(df, xydf)
    df
}


###################################################
### code chunk number 12: ChromBand.Rnw:642-657
###################################################

gseaTstatStripplot <- function(bands, g, ..., include.all = FALSE)
{
    chroms <- c(1:22, "X", "Y")
    chromArms <- c(paste(chroms, "p", sep=""), paste(chroms, "q", sep=""))
    egid <- lapply(nodeData(g, bands), "[[", "geneIds")
    if (include.all) {
        egid$All <- 
            unique(unlist(lapply(nodeData(g)[chromArms], "[[", "geneIds")))
    }
    tdf <- do.call(make.groups, lapply(egid, function(x) tstats[x]))
    stripplot(which ~ data, tdf, jitter = TRUE, ...)
}




###################################################
### code chunk number 13: ChromBand.Rnw:662-709
###################################################

esetBWPlot <- function(tmpSet, ..., layout=c(1, nrow(emat)))
{
    emat <- exprs(tmpSet)
    pd <- pData(tmpSet)
    probes <- rownames(emat)
    syms <- 
        sapply(mget(probes, hgu95av2SYMBOL, ifnotfound=NA),
               function(x) if (all(is.na(x))) "NA" else as.character(x)[1])
    selectedAffy <- 
        probes %in% affyUniverse[selectedEntrezIds]
    symsSelected <- syms[selectedAffy]
    symsWithStatus <- 
        paste(syms, 
              ifelse(selectedAffy, "*", ""), 
              sep = "")
    pdat <- 
        cbind(exprs=as.vector(emat),
              genes=factor(probes, levels = probes, labels = syms),
              pd[rep(seq_len(nrow(pd)), each=nrow(emat)), ])
    pdat <- transform(pdat, genes = reorder(genes, exprs))
    panels.to.shade <- levels(pdat$genes) %in% symsSelected
    bwplot(mol.biol ~ exprs | genes, data=pdat, 
           layout = layout,
           auto.key=TRUE,
           scales=list(x=list(log=2L)),
           xlab="Log2 Expression",
           panels.to.shade = panels.to.shade,
           panel = function(..., panels.to.shade) {
               if (panels.to.shade[packet.number()]) 
                   panel.fill(col = "lightgrey")
               panel.bwplot(...)
           },
           strip=FALSE,
           strip.left=TRUE, ...)
}

g1 <- makeChrBandGraph(annotation(nsFiltered), univ=entrezUniverse)
ct <- ChrBandTreeFromGraph(g1)

subsetByBand <- function(eset, ct, band) {
    egIDs <- unlist(nodeData(ct@toChildGraph, n=band, 
                             attr="geneIds"), use.names=FALSE)
    wantedProbes <- affyUniverse[as.character(egIDs)]
    eset[intersect(wantedProbes, featureNames(eset)), ]
}



###################################################
### code chunk number 14: basicParams
###################################################
params <- new("ChrMapHyperGParams",
              conditional=FALSE,
              testDirection="over",
              universeGeneIds=entrezUniverse,
              geneIds=selectedEntrezIds,
              annotation="hgu95av2",
              pvalueCutoff=0.05)

paramsCond <- params
paramsCond@conditional <- TRUE


###################################################
### code chunk number 15: basicTest
###################################################
hgans <- hyperGTest(params)
hgansCond <- hyperGTest(paramsCond)


###################################################
### code chunk number 16: result1
###################################################
sumUn <- summary(hgans, categorySize=1)
chrSortOrder(sumUn)

sumCond <- summary(hgansCond, categorySize=1)
chrSortOrder(sumCond)


###################################################
### code chunk number 17: ChromBand.Rnw:800-815
###################################################
gseaTstatStripplot(c("12q21.1", "12q21", "12q2", "12q"),
                   include.all = TRUE, 
                   g = g1,
                   xlab = "Per-gene t-statistics", 
                   panel = function(...) {
                       require(grid, quietly = TRUE)
                       grid.rect(y = unit(2, "native"), 
                                 height = unit(1, "native"),
                                 gp = 
                                 gpar(fill = "lightgrey", 
                                      col = "transparent"))
                       panel.grid(v = -1, h = 0)
                       panel.stripplot(...)
                       panel.average(..., fun = mean, lwd = 3)
                   })


###################################################
### code chunk number 18: gseaStripplot
###################################################
plot(trellis.last.object())


###################################################
### code chunk number 19: LMtestSetup
###################################################
params <- new("ChrMapLinearMParams",
              conditional = FALSE,
              testDirection = "up",
              universeGeneIds = entrezUniverse,
              geneStats = tstats,
              annotation = "hgu95av2",
              pvalueCutoff = 0.01, 
              minSize = 4L)
params@graph <- makeChrBandGraph(params@annotation, params@universeGeneIds)
params@gsc <- makeChrBandGSC(params@graph)
paramsCond <- params
paramsCond@conditional <- TRUE


###################################################
### code chunk number 20: LMtest
###################################################

lmans <- linearMTest(params)
lmansCond <- linearMTest(paramsCond)

chrSortOrder(summary(lmans))
chrSortOrder(summary(lmansCond))

##


###################################################
### code chunk number 21: ChromBand.Rnw:919-922
###################################################
tmpSet <- subsetByBand(nsFiltered, ct, "1p36.2")
esetBWPlot(tmpSet, ylab="1p36.2", layout = c(2, 8),
           par.strip.text = list(cex = 0.8))


###################################################
### code chunk number 22: dotplot1p362
###################################################
plot(trellis.last.object())


