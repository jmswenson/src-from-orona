### R code from vignette source 'IntroToAnnotationPackages.Rnw'

###################################################
### code chunk number 1: select
###################################################
library(org.Hs.eg.db)
cols(org.Hs.eg.db)
keytypes(org.Hs.eg.db)
uniKeys <- head(keys(org.Hs.eg.db, keytype="UNIPROT"))
cols <- c("SYMBOL", "PATH")
select(org.Hs.eg.db, keys=uniKeys, cols=cols, keytype="UNIPROT")



###################################################
### code chunk number 2: select
###################################################
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
txdb
cols(txdb)
keytypes(txdb)
keys <- head(keys(txdb, keytype="GENEID"))
cols <- c("TXID", "TXSTART")
select(txdb, keys=keys, cols=cols, keytype="GENEID")



###################################################
### code chunk number 3: getMetadata
###################################################
library(hom.Hs.inp.db)
hom.Hs.inp_dbInfo()


###################################################
### code chunk number 4: referenceClass (eval = FALSE)
###################################################
## .InparanoidDb <-
##     setRefClass("InparanoidDb", contains="AnnotationDb")


###################################################
### code chunk number 5: onLoad (eval = FALSE)
###################################################
## sPkgname <- sub(".db$","",pkgname)
## txdb <- loadDb(system.file("extdata", paste(sPkgname,
##                ".sqlite",sep=""), package=pkgname, lib.loc=libname),
##                packageName=pkgname)
## dbNewname <- AnnotationDbi:::dbObjectName(pkgname,"InparanoidDb")
## ns <- asNamespace(pkgname)
## assign(dbNewname, txdb, envir=ns)
## namespaceExport(ns, dbNewname)


###################################################
### code chunk number 6: classicConn
###################################################
drv <- SQLite()
library("org.Hs.eg.db")
con <- dbConnect(drv, dbname=system.file("extdata", "org.Hs.eg.sqlite",
                        package = "org.Hs.eg.db"))
con


###################################################
### code chunk number 7: ourConn
###################################################
str(hom.Hs.inp.db)


###################################################
### code chunk number 8: ourConn2
###################################################
hom.Hs.inp.db$conn
## or better we can use a helper function to wrap this
AnnotationDbi:::dbConn(hom.Hs.inp.db)


###################################################
### code chunk number 9: dbListTables
###################################################
con <- AnnotationDbi:::dbConn(hom.Hs.inp.db)
head(dbListTables(con))
dbListFields(con, "Mus_musculus")


###################################################
### code chunk number 10: dbGetQuery
###################################################
dbGetQuery(con, "SELECT * FROM metadata")


###################################################
### code chunk number 11: dbListTables2
###################################################
con <- AnnotationDbi:::dbConn(hom.Hs.inp.db)
head(dbListTables(con))


###################################################
### code chunk number 12: dbListFields2
###################################################
dbListFields(con, "Apis_mellifera")


###################################################
### code chunk number 13: dbGetQuery2
###################################################
head(dbGetQuery(con, "SELECT * FROM Apis_mellifera"))


###################################################
### code chunk number 14: Anopheles (eval = FALSE)
###################################################
## head(dbGetQuery(con, "SELECT * FROM Anopheles_gambiae"))
## ## Then only retrieve human records
## ## Query: SELECT * FROM Anopheles_gambiae WHERE species='HOMSA'
## head(dbGetQuery(con, "SELECT * FROM Anopheles_gambiae WHERE species='HOMSA'"))


###################################################
### code chunk number 15: cols (eval = FALSE)
###################################################
## .cols <- function(x){
##   con <- AnnotationDbi:::dbConn(x)
##   list <- dbListTables(con)
##   ## drop unwanted tables
##   unwanted <- c("map_counts","map_metadata","metadata")
##   list <- list[!list %in% unwanted]
##   ## Then just to format things in the usual way
##   toupper(list)
## }
## 
## ## Then make this into a method
## setMethod("cols", "InparanoidDb", .cols(x))
## ## Then we can call it
## cols(hom.Hs.inp.db)


###################################################
### code chunk number 16: keytypes (eval = FALSE)
###################################################
## setMethod("keytypes", "InparanoidDb", .cols(x))
## ## Then we can call it
## keytypes(hom.Hs.inp.db)
## 
## ## refactor of .cols
## .getLCcolnames <- function(x){
##   con <- AnnotationDbi:::dbConn(x)
##   list <- dbListTables(con)
##   ## drop unwanted tables
##   unwanted <- c("map_counts","map_metadata","metadata")
##   list <- list[!list %in% unwanted]
## }
## .cols <- function(x){
##   list <- .getLCcolnames(x)
##   ## Then just to format things in the usual way
##   toupper(list)
## }
## ## Test:
## cols(hom.Hs.inp.db)
## 
## ## new helper function:
## .getTableNames <- function(x){
##   LC <- .getLCcolnames(x)
##   UC <- .cols(x)
##   names(UC) <- LC
##   UC
## }
## .getTableNames(hom.Hs.inp.db)


###################################################
### code chunk number 17: keys (eval = FALSE)
###################################################
## .keys <- function(x, keytype){
##   ## translate keytype back to table name
##   tabNames <- .getTableNames(x)
##   lckeytype <- names(tabNames[tabNames %in% keytype])
##   ## get a connection
##   con <- AnnotationDbi:::dbConn(x)
##   sql <- paste("SELECT inp_id FROM",lckeytype, "WHERE species!='HOMSA'")
##   res <- dbGetQuery(con, sql)
##   as.vector(t(res))
## }
## 
## setMethod("keys", "InparanoidDb", .keys(x, keytype))
## ## Then we can call it
## keys(hom.Hs.inp.db, "TRICHOPLAX_ADHAERENS")


