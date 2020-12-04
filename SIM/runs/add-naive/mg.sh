#!/bin/bash
cd $1
echo $PWD> a.sh
echo $PWD
multiGWAS.R $2
