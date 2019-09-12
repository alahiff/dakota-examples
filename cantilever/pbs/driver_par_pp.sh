#!/bin/bash

# $1 and $2 are special variables in bash that contain the 1st and 2nd 
# command line arguments to the script, which are the names of the
# Dakota parameters and results files, respectively.

params=$1
results=$2

###############################################################################
##
## Determine the name of the directory to read from
##
###############################################################################

num=$(echo $1 | awk -F. '{print $NF}')
topdir=`pwd`
workdir=$topdir/workdir.$num

############################################################################### 
##
## Create a DAKOTA results file
##
################################################################################

cd $workdir

mass=$(grep "(lb)" stdout | awk '{print $1}')
stress=$(grep "(lb/in^2)" stdout | awk '{print $1}')
displacement=$(grep "(in))" stdout | awk '{print $1}')

echo "$mass mass" > $topdir/$results
echo "$stress stress" >> $topdir/$results
echo "$displacement displacement" >> $topdir/$results

