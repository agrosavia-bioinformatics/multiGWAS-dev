#!/usr/bin/Rscript
library (doParallel)
library (ldsep)
source ("lglib07.R")


#------------------------------------------------------------------------
# Match SNPs by LD and select the best tagSNP when r2=1
#------------------------------------------------------------------------
matchSNPsByLDAllTools <- function (genoFile, scoresFile, maxLD) {
	scores = read.table (scoresFile, sep="\t", header=T)
	geno   = read.csv (genoFile, row.names=1)

	# Create hash list of SNPs
	snpList = list()
	snps    = as.character (scores [, "SNP"])
	snpList = sapply  (snps, function (x) append (snpList,x))

	# Create genotype matrix from SNPs
	genoSNPs    = as.matrix (geno [snps,-1:-2]); view (genoSNPs)
	ldmat       = mldest(geno = genoSNPs, K = 4, nc = 7, type = "comp", se=F);
	ldSNPs      = ldmat [, c(3,4,7)]
	ldSNPs$snpi = sapply (ldSNPs$snpi, function (x) strsplit (x, "[.]")[[1]][1])
	ldSNPs$snpj = sapply (ldSNPs$snpj, function (x) strsplit (x, "[.]")[[1]][1])

	# Filter SNPs by R2
	ldSNPsFiltered = ldSNPs [ldSNPs$snpi!=ldSNPs$snpj,]
	ldSNPsFiltered = ldSNPsFiltered [!duplicated (ldSNPsFiltered[c(1,2)]),]
	ldSNPsR2       = ldSNPsFiltered [ldSNPsFiltered$r2 > maxLD,] ; ldSNPsR2

	# Match SNPs
	n = nrow (ldSNPsR2)
	for (i in n:1) {
		snpi = ldSNPsR2 [i, "snpi"]
		snpj = ldSNPsR2 [i, "snpj"]
		snpList [snpList %in% snpj] = snpi
	}
	#scores = data.frame (SNPLD=as.character (snpList), scores)
	scores$SNP = as.character (snpList)
	outFile = addLabel (scoresFile, "LD")
	write.table (scores, outFile, sep="\t", col.names=T, row.names=F, quote=F)
}

#--------------------------------------------------------------
#--------------------------------------------------------------

scoresFile = "in/out-multiGWAS-scoresTable-best.scores"
genoFile   = "in/filtered-gwasp4-genotype-MAF-NUM.tbl"
maxLD      = 0.99

matchSNPsByLDAllTools (genoFile, scoresFile, maxLD)













