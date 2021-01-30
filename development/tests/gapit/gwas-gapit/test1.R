#!/usr/bin/Rscript
library (GAPIT3)

#Step 1: Set data directory and import files
genoNumFile = "example-genotype-tetra-gwaspoly-ACGT-GAPIT-NUM.csv"
genoMapFile = "example-genotype-tetra-gwaspoly-ACGT-GAPIT-MAP.csv"
phenoFile   = "example-phenotype-single-trait-GAPIT.csv"

genoNumFile = "data/geno.csv"
genoMapFile = "data/map.csv"
phenoFile   = "data/pheno.csv"

myY  = read.csv(phenoFile, head = TRUE)
myGM = read.csv(genoMapFile , head = TRUE)
myGD = read.csv(genoNumFile, head = TRUE)

#Step 2: Run GAPIT
myGAPIT <- GAPIT(Y=myY, GD=myGD, GM=myGM,model="GLM", file.output=F)
write.csv (myGAPIT$GWAS, "out-GAPIT.csv", quote=F, row.names=F)

