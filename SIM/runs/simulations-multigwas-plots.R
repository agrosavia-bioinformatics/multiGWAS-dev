#!/usr/bin/Rscript
# Create plots from GS results. First merge GS results in
# a single table, them it creates two boxplots: one with
# all models by trait, and another with the best models bt
# trait

suppressMessages (library (dplyr))
suppressMessages (library (ggplot2))

#--------------------------------------------------------------------
# Get data (True and Negative Positives) from MultiGWAS results
#--------------------------------------------------------------------
getStatistics <- function (NRUNS, CONFIGFILE, SCORESFILE) {
	statsTable = NULL
	for (i in 1:NRUNS) { 
		dirRun      = paste0 ("run", i)
		dirGwas     = strsplit (CONFIGFILE, "[.]")[[1]][1]
		fileScores  = sprintf ("%s/out-%s/TraitX/report/%s", dirRun, dirGwas, SCORESFILE)

		# Get marker names of QTNs
		causalSNPs  = as.character (read.csv (paste0 (dirRun,"/qtns-markers.csv")) [,"Marker"])
		nCausal    = length (causalSNPs)

		# Get results from scores table
		scores      = read.table (fileScores, header=T)
		toolList    = levels (scores$TOOL)
		nTools      = length (toolList)
		mgToolList = c ("MultiGWAS", toolList)

		message (">>> RUN", i, ":")
		for (tool in mgToolList) {
			message (">>> TOOL ", tool, ":")
			if (tool=="MultiGWAS") {
				sharedSNPs = scores %>% group_by (SNP) %>% mutate (count=n()) %>% filter (count > 1) %>% 
					select (SNP, count) %>% unique %>% data.frame
				snps       = as.character (unique (sharedSNPs [sharedSNPs$count == nTools, c("SNP")]))
				signSNPs   = as.character (unique (scores [scores$SNP %in% snps & scores$SIGNIFICANCE==TRUE, c("SNP")]))
				print (sharedSNPs)
			}else {
				snps       = as.character (scores [scores$TOOL==tool, c("SNP")])
				signSNPs   = as.character (scores [scores$TOOL==tool & scores$SIGNIFICANCE==TRUE, c("SNP")])
			}
				message (">> snps    : ", sprintf ("%s ", snps))
				message (">> signSNPs: ", sprintf ("%s ", signSNPs))

			# True positive rate detected
			TPd   = intersect (causalSNPs, snps)
			FNd   = setdiff (snps, TPd)
			nTPd  = length (TPd)
			nFNd  = length (FNd)
			nTPRd = nTPd+nFNd
			TPRd  = nTPd / nTPRd
			#TPRd  = if (nTPRd==0) 0 else nTPd / nTPRd

			# True positive rate signigicants
			TPs   = intersect (causalSNPs, signSNPs)
			FNs   = setdiff (signSNPs, TPs)
			nTPs  = length (TPs)
			nFNs  = length (FNs)
			nTPRs = nTPs + nFNs
			TPRs  = nTPs / nTPRs
			#TPRs  = if (nTPRs==0) 0 else nTPs / nTPRs

			stats      = data.frame (RUN=dirRun, TOOL=tool, 
									 nTPRd=nTPRd, nTPd=nTPd, nFNd=nFNd, TPRd=TPRd,
									 nTPRs=nTPRs, nTPs=nTPs, nFNs=nFNs, TPRs=TPRs)

			statsTable = if (is.null (statsTable)) stats else rbind (statsTable, stats)
		}
	}
	statsFile = "out-table-stats-TruePositive.csv"
	message ("Writting statistics for true positive rate...")
	write.csv (statsTable, statsFile, quote=F, row.names=F)
	return (statsFile)
}

#-------------------------------------------------------------
# Main
#-------------------------------------------------------------
args = commandArgs(trailingOnly = TRUE)
args = c("out-table-stats-TruePositive.csv")

NCORES=7
runDir = "run"
NRUNS = length (grep ("run", list.dirs(recursive=F),value=T))

CONFIGFILE = "full-tetra-Filters-ADD.config"
SCORESFILE = "out-multiGWAS-scoresTable-best.scores"

statsFile = getStatistics (NRUNS, CONFIGFILE, SCORESFILE) 

# Read tables
statsTable       = read.csv (statsFile)
toolColors = 1:5

TPsignFile = "out-plot-truePositiveRate-detected.pdf"
ggplot (data=statsTable , aes(x=TOOL, y=TPRd)) + 
	geom_boxplot (alpha=0.3, fill=toolColors ) + 
	labs (title="True positive rate for detected SNPS (TPRd)") 
	#theme(axis.text.x=element_text(angle=0, hjust=2)) 
ggsave (TPsignFile, width=7, height=7)

signFile = "out-plot-truePositiveRate-significants.pdf"
ggplot (data=statsTable , aes(x=TOOL, y=TPRs)) + 
	geom_boxplot (alpha=0.3, fill=toolColors ) + 
	labs (title="True positive rate for significant SNPs (TPRs)")
	#theme(axis.text.x=element_text(angle=0, hjust=3)) 
ggsave (signFile, width=7, height=7)

#detectedRateFile = "out-plot-detectedRate.pdf"
#ggplot (data=statsTable , aes(x=TOOL, y=DetecRate)) + 
#	geom_boxplot (alpha=0.3, fill=toolColors ) + labs (title="Detected SNPs rate for simulated data") 
	#theme(axis.text.x=element_text(angle=0, hjust=1)) 
#ggsave (detectedRateFile, width=7, height=7)

