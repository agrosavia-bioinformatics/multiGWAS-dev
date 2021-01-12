#!/usr/bin/Rscript
library (doParallel)
library (ldsep)

set.seed(1)
## Simulate genotypes when true correlation is 0
nloci <- 5
nind <- 100
K <- 4
nc <- 7
genomat1 <- matrix(sample(0:K, nind * nloci, TRUE), nrow = nloci)
gm = as.matrix (read.csv ("gm.csv", header=T, row.names=1))
## Composite LD estimates
m1 = "c1_16001"
m2 = "c2_45611"
g1 = gm ["c2_45606",]
g2 = gm ["c2_45611",]

lddf <- ldest(ga=g1, gb=g2, K = K, type = "comp")
genomat=genomat1
lddf <- mldest(geno = genomat, K = K, nc = nc, type = "comp", se=F)

lddf["r2"]
write.csv (lddf, "out-lddf.csv", row.names=F, quote=F)

