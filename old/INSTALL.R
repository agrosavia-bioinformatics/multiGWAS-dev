#
# Create multiGWAS profile according to current directory
# 
#

# Create multiGWAS profile
message ("Creating multiGWAS profile...")

sink ("multiGWAS-profile.sh", append=F)
writeLines ("")
writeLines ("#------------------- multiGWAS.R profile ---------------------")
MULTIGWAS_HOME = getwd ()
writeLines (paste0 ("export MULTIGWAS_HOME=", getwd()))
writeLines ("MULTIGWAS_TOOLS=$MULTIGWAS_HOME/tools")
writeLines ("MULTIGWAS_SOURCES=$MULTIGWAS_HOME/sources")
writeLines ("export PATH=$PATH:$MULTIGWAS_TOOLS:$MULTIGWAS_SOURCES")
sink()

message ("")
message ("MultiGWAS is ready to use, right after installed!")
message ("")

# Write into .profile
profileFile = paste0 (path.expand ("~"), "/.profile")
sink (profileFile, append=T)
writeLines ("")
writeLines ("#------------------- multiGWAS.R tool profile ---------------------")
writeLines (paste0 ("source ", getwd(), "/multiGWAS-profile.sh"))
sink ()

# Install R libraries
libpath = paste0 (MULTIGWAS_HOME, "/opt/Rlibs")
message ("\n\nInstalling R libraries...\n\n")

.libPaths (libpath)

if (!require("pacman")) install.packages('pacman', lib=libpath, repos='http://cran.us.r-project.org')

pacman::pRload("rrBLUP", "parallel","config","dplyr","stringi","vcfR","qqman","VennDiagram","RColorBrewer","circlize","gplots") 

if (!require("GWASpoly")) install.packages('GWASpoly_1.3.tar.gz', lib=libpath, repos=NULL, type="source")
