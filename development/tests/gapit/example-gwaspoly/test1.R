#!/usr/bin/Rscript
library (GAPIT3)

#Step 1: Set data directory and import files
genoNumFile = "example-genotype-tetra-gwaspoly-ACGT-GAPIT-NUM.csv"
genoMapFile = "example-genotype-tetra-gwaspoly-ACGT-GAPIT-MAP.csv"
phenoFile   = "example-phenotype-single-trait.csv"

myY  = read.table(phenoFile, head = TRUE)
myGM = read.table(genoMapFile , head = TRUE)
myGD = read.table(genoNumFile, head = TRUE)

#Step 2: Run GAPIT
myGAPIT <- GAPIT(Y=myY, GD=myGD, GM=myGM, model="FarmCPU")

