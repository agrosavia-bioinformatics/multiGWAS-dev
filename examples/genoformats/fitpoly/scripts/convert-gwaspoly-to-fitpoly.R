#!/usr/bin/Rscript
source ("lglib06.R")

#-------------------------------------------------------------
# Convert GWASpoly genotype to fitPoly scores
# Write two table: fitPoly scores and map info
#-------------------------------------------------------------
convertGwaspolyGenoToFitpolyScores <- function (gwpFile) {
	#----
	convert <- function (row) {
		sampleNames = names (row)[-c(1:2)]
		values      = as.numeric (row [-c(1:2)])
		n           = length (values)
		maxgeno     = geno = values
		geno [is.na(values)] = ""
		rowDF = data.frame (
			marker=as.character (row[1]), MarkerName=as.character (row[2]),
			SampleName=sampleNames, ratio=runif (n,0,1), P0=runif (n,0,1), 
			P1=runif (n,0,1), P2=runif (n,0,1), P3=runif (n,0,1), P4=runif (n,0,1),
			maxgeno=values, maxP=runif (n,0,1), geno=geno)
		return (rowDF)
	}

	gwpTable = read.csv (gwpFile) 
	gwpTable = gwpTable [order(gwpTable[,1]),]
	mapTable = gwpTable [,1:3]
	write.csv (mapTable, addLabel (gwpFile, "MAP"), quote=F, row.names=F)

	gwpTable = gwpTable [,-2:-3]
	gwpTable = data.frame (marker=seq(nrow(gwpTable)), gwpTable)

	fitpolyTable = do.call (rbind.data.frame, apply (gwpTable, 1, convert))
	write.table (fitpolyTable, addLabel (gwpFile, "FITPOLY"), quote=F, row.names=F, sep="\t")
}

gwpFile = "example-genotype-tetra-NUM.csv"
convertGwaspolyGenoToFitpolyScores (gwpFile)


