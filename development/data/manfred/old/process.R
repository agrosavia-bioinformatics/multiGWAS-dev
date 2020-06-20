#!/usr/bin/Rscript

#source ("lgRlib.R")

args = commandArgs(trailingOnly = TRUE)

filename = args [1]
message (filename)

data = read.csv (file=filename, sep="\t", check.names=F)
#hd (data)

cols = ncol (data)

index = seq (from=4, to=cols, by=2)

genos = data [, index] 

newData = cbind (data[,1:3], genos)
#hd (newData)

newFilename = paste0 (strsplit (filename, "[.]")[[1]][1], "-genos.csv")
write.table (file=newFilename, newData, sep="\t", quote=F, row.names=F)

