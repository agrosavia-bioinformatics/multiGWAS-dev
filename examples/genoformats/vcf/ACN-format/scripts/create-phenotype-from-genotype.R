#!/usr/bin/python

args = commandArgs (trailingOnly=T)
options (width=300)

# Only for test
args = c ("x-example-genotype-tetra-ACN-FORMAT.vcf")
genoFile = args [1]

geno = read.table (genoFile, comment="#", header=1, check.names=F)
samples = colnames (geno)[-1:-9]

