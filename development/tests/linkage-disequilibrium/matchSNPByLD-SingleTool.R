#!/usr/bin/Rscript
library (doParallel)
library (ldsep)
source ("lglib07.R")

#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
# Return a new matrix with SNPs matched by LD
matchSNPsByLD <- function (genoFile, scoresFile, maxLD, maxBest) {
	geno    = read.csv (genoFile, row.names=1);view (geno)
	scores  = read.table (scoresFile, sep="\t", header=T); view (scores)
	genomat = as.matrix (geno [,-1:-2]); view (genomat)
	view (scores, n=20, m=10)

	# Get Top SNPs from score file
	N=2*maxBest
	snpList = as.character (scores [1:N,c("Marker")]); view (snpList)

	# Get genotypes for SNPs and calculate LD matrix (r2)
	genomatSNPs = genomat [snpList,]; view (genomatSNPs,n=10)
	ldMatrixAll = mldest(geno = genomatSNPs, K = 4, nc = 7, type = "comp", se=F);
	ldMatrix    = ldMatrixAll [,c(3,4,7)]

	# Replace SNPs with LD SNPs
	i = 1
	while (i < nrow (ldMatrix)) {
		if (ldMatrix[i,"r2"] > maxLD) {
			print (ldMatrix[i,])
			snpj     = ldMatrix [i, "snpj"]
			ldMatrix = ldMatrix [ldMatrix$snpi != snpj,]
		}
		i = i+1
	}
	ldMatrixMatched = ldMatrix [!duplicated (ldMatrix$snpi),]
	bestMatchedSNPs = ldMatrixMatched [1:maxBest, "snpi"]
	scoresLD        = scores [scores$Marker %in% bestMatchedSNPs,]
	scoresLDFile    = addLabel (scoresFile, "LD")
	write.table (scoresLD, scoresLDFile, sep="\t", col.names=T, row.names=F, quote=F)
	return (scoresLDFile)
}

# LD r2 threshold
maxLD = 0.99
# Read geno and scores files
genoFile   = "in/filtered-gwasp4-genotype-MAF-NUM.tbl"
scoresFile = "in/tool-PLINK-scores-additive-full.csv"


mat = matchSNPsByLD (genoFile, scoresFile, maxLD, 10)
print (mat)

