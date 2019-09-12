#!/bin/bash

# $1 and $2 are special variables in bash that contain the 1st and 2nd 
# command line arguments to the script, which are the names of the
# Dakota parameters and results files, respectively.

params=$1
results=$2

###############################################################################
##
## Create working directory with a unique name
##
###############################################################################

num=$(echo $1 | awk -F. '{print $NF}')
topdir=`pwd`
workdir=$topdir/workdir.$num

mkdir workdir.$num

############################################################################### 
##
## Pre-processing Phase -- Generate/configure an input file for your simulation 
##  by substiting in parameter values from the Dakota paramters file.
##
###############################################################################

dprepro $params cantilever.template cantilever.i

cp cantilever.i $workdir/.

############################################################################### 
##
## Execution Phase -- Run your simulation
##
###############################################################################

# Instead of running the simulation, generate a PBS submission script for
# this function evaluation and submit it to the queue

cd $workdir

echo "#!/bin/bash" > pbs_submission
echo "#PBS -l nodes=1:ppn=1" >> pbs_submission
echo "#PBS -l walltime=00:05:00" >> pbs_submission
echo "#PBS -N DAKOTA_UQ_CASE4" >> pbs_submission
echo "# in = $params out = $results " >> pbs_submission

echo "cd $workdir" >> pbs_submission

echo "../cantilever cantilever.i > cantilever.log" >> pbs_submission

chmod a+x pbs_submission
qsub pbs_submission

############################################################################### 
##
## Need to write a results file so DAKOTA will proceed with the next
## job generation:
##
################################################################################

mass=1.00
stress=1.00
displacement=1.00

echo "$mass mass" > $topdir/$results
echo "$stress stress" >> $topdir/$results
echo "$displacement displacement" >> $topdir/$results

