#!/usr/bin/Rscript
library (parallel)
library (dplyr)

args = commandArgs (trailingOnly=T)

#-------------------------------------------------------------
# Run seqBreed simulations
#-------------------------------------------------------------
runSimulations <- function (NRUNS, NCORES) {
	message (">>> Creating dirs...")
	cmmListSims = c()
	for (i in 1:NRUNS) {
		runDir = paste0 ("run", i)
		cmmSim = sprintf ("potato-simCCC.py %s", runDir)
		cmmListSims = c(cmmListSims, cmmSim)
	}

	mclapply (cmmListSims, system, mc.cores=NCORES)

	message (">>>> Running simulations..")
	for (i in 1:NRUNS) {
		runDir = paste0 ("run", i)
		cmm = sprintf ("ln -s $PWD/%s  %s/", CONFIGFILE, runDir) 
		system (cmm)
	}
}

#-------------------------------------------------------------
# Run MultiGWAS for each simulation
#-------------------------------------------------------------
runMultiGWAS <- function (NRUNS, CONFIGFILE, GENOFILE, QTNSFILE) {
	message (">>> Running MultiGWAS...")
	cmmListSims = c()
	for (i in 1:NRUNS) {
		dirRun = paste0 ("run", i)
		cmmSim = sprintf ("mg.sh %s %s", dirRun, CONFIGFILE)
		cmmListSims = c(cmmListSims, cmmSim)
	}

	mclapply (cmmListSims, system, wait=T, mc.cores=NCORES)
}

#------------------------------------------------------------------------
# Get marker names of QTNs
#------------------------------------------------------------------------
setMarkerNamesToQTNs <- function (NRUNS, CONFIGFILE, GENOFILE, QTNSFILE) {
	for (i in 1:NRUNS) {
		dirRun = paste0 ("run", i)
		dirGwas     = strsplit (CONFIGFILE, "[.]")[[1]][1]
		fileGeno    = sprintf ("%s/out-%s/TraitX/%s", dirRun, dirGwas, GENOFILE)
		geno        = read.csv (fileGeno)
		qtns        = read.table (paste0 (dirRun,"/",QTNSFILE), comment.char="#", header=F)
		qtnsMarkers = merge (geno, qtns , by.x=c("Chromosome", "Position"), by.y=c("V1","V2"))
		qtnsMarkers = qtnsMarkers [,c(c(1:3),(ncol(qtnsMarkers)-3):ncol(qtnsMarkers))]
		write.csv (qtnsMarkers, paste0 (dirRun,"/","qtns-markers.csv"), row.names=F, quote=F)
	}
}

#-------------------------------------------------------------
# Main
#-------------------------------------------------------------
# Constants
NCORES     = 7
runDir     = "run"
NRUNS      = 20
QTNSFILE   = "qtns.tsv"
CONFIGFILE = "full-tetra-Filters-DOM-NAIVE.config"
SCORESFILE = "out-multiGWAS-scoresTable-best.scores"
GENOFILE   = "genotype-simulated-SeqBreed-tetra-GWASPOLY.csv"

runSimulations (NRUNS, NCORES)


runMultiGWAS (NRUNS, CONFIGFILE, GENOFILE, QTNSFILE)

setMarkerNamesToQTNs (NRUNS, CONFIGFILE, GENOFILE, QTNSFILE) 

dirGwas     = strsplit (CONFIGFILE, "[.]")[[1]][1]
message ("Opening htmls...")
cmmListSims = c()

for (i in 1:NRUNS) {
	runDir = paste0 ("run", i)
	cmmSim = sprintf ("file://%s/%s/out-%s/TraitX/multiGWAS-report.html", getwd(), runDir, dirGwas)
	cmmListSims = c(cmmListSims, cmmSim)
}

system (paste0 ("chromium ", Reduce (paste, cmmListSims)))
#quit ()



