#!/usr/bin/Rscript
#library (GAPIT3)
source ("gapit_functions-formated.R")

#Step 1: Set data directory and import files
myY <- read.table("data/mdp_traits-EarHT.tsv", head = TRUE)
myGD <- read.table("data/mdp_numeric-DOM.txt", head = TRUE)
myGM <- read.table("data/mdp_SNP_information.txt" , head = TRUE)

#Step 2: Run GAPIT
out=myGAPIT <- GAPIT( Y=myY, GD=myGD, GM=myGM, model="MLM", SNP.effect="Add", file.output=F )

#Step 1: Set data directory and import files
#myY  <- read.table("mdp_traits-EarHT.tsv", head = TRUE)
#myG <- read.delim("mdp_genotype_test.hmp.txt", head = FALSE)

#Step 2: Run GAPIT
#out=myGAPIT <- GAPIT(Y=myY, G=myG, SNP.effec="Add")


