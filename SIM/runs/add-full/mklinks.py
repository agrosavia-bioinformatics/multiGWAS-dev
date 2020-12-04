#!/usr/bin/python 
import os

for i in range (1,6):
	run = "run" + str(i)
	cmm = "ln -s $PWD/full-tetra-Filters-ADD.config %s/" % run
	os.system (cmm)


