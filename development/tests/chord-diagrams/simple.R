#!/usr/bin/Rscript

library(circlize)

mat = matrix (c(1,0,1,1,0,
				1,0,0,1,1,
				0,0,0,0,1,
				1,1,0,0,1), nrow=4)
mat


colors = c("C1"="red", "C2"="green", "C3"="blue", "C4"="grey")

colnames (mat) = c("s1","s2","s3","s4", "s5")
rownames (mat) = c("C1","C2","C3", "C4")
print (mat)

chordDiagram (mat, grid.col=colors)

