#!/usr/bin/python

args = commandArgs (trailingOnly=T)
options (width=300)

# Only for test
args = c ("x-example-genotype-tetra-ACN-FORMAT.vcf")
genoFile = args [1]

geno = read.table (genoFile, comment="#", header=1, check.names=F)
individualas = colnames (geno)[-1:-9]
n = length (individualas)

randomPhenos = runif (n, 0,1)

pheno = data.frame (NAME=samples, TRAITX=randomPhenos)

write.csv (pheno, "example-phenotype-random-values.csv", row.names=F, quote=F)



