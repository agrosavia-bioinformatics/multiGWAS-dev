libpath = paste0 (path.expand ("~"), "/R")
.libPaths (libpath)

if (!require("pacman")) install.packages('pacman', lib=libpath, repos='http://cran.us.r-project.org')

pacman::p_load("rrBLUP", "parallel","config","dplyr","stringi","vcfR","qqman","VennDiagram","RColorBrewer","circlize","gplots") 

if (!require("GWASpoly")) install.packages('GWASpoly_1.3.tar.gz', lib=libpath, repos=NULL, type="source")
