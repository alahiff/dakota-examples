# JOREK parameter scan + Dakota optimise

## Submitting the workflow
To run the full parameter scan with optimisation for each parameter set, run the following:
```
prominence run jorek-sweep-opt-2.json
```
To check the status, run:
```
$ prominence list workflows
ID      NAME                             CREATED               STATUS    ELAPSED      PROGRESS
25313   jorek-sweep-optimise-with-data   2019-10-23 06:19:01   running   0+00:01:21   0/9  
```
The following command can be run to see the individual jobs which have been created:
```
$ prominence list
ID      NAME                                                     CREATED               STATUS      ELAPSED      IMAGE               CMD                                                               
25314   jorek-sweep-optimise-with-data/dakota-jorek-optimise/0   2019-10-23 06:19:05   deploying                jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25315   jorek-sweep-optimise-with-data/dakota-jorek-optimise/1   2019-10-23 06:19:05   deploying                jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25316   jorek-sweep-optimise-with-data/dakota-jorek-optimise/2   2019-10-23 06:19:07   deploying                jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25317   jorek-sweep-optimise-with-data/dakota-jorek-optimise/3   2019-10-23 06:19:07   deploying                jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25318   jorek-sweep-optimise-with-data/dakota-jorek-optimise/4   2019-10-23 06:19:09   deploying                jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25319   jorek-sweep-optimise-with-data/dakota-jorek-optimise/5   2019-10-23 06:19:09   deploying                jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25320   jorek-sweep-optimise-with-data/dakota-jorek-optimise/6   2019-10-23 06:19:11   deploying                jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25321   jorek-sweep-optimise-with-data/dakota-jorek-optimise/7   2019-10-23 06:19:12   deploying                jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25322   jorek-sweep-optimise-with-data/dakota-jorek-optimise/8   2019-10-23 06:19:14   deploying                jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
```
Note that currently, by default, only up to 20 idle jobs will be created at a time. Once the jobs start running more will be created.

## Downloading the output files and work directories
Each job will create a tarball containing:
* dakota_jorek.out
* dakota_jorek.dat
* all the work directories created by Dakota

which will be automatically uploaded to ECHO as each job completed.

The status can be checked by running `prominence list workflows`:
```
$ prominence list workflows
ID      NAME                             CREATED               STATUS    ELAPSED      PROGRESS
25313   jorek-sweep-optimise-with-data   2019-10-23 06:19:01   running   0+00:29:32   4/9
```
When the workflow has completed you will need to add `--completed` to the above command in order to see it, i.e.
```
```

Once the workflow has completed, the script `get-all-outputs` can be used to download all
```
python get-all-outputs thing=6C5B8EFA
```
This script will create a unique directory for each job and download the output tarball from ECHO. The `thing=6C5B8EFA` is a constraint on the jobs, i.e. it will find all jobs which have a label `thing` with value `6C5B8EFA`. If you look at the file `jorek-sweep-opt-2.json` you can see this defined. Note that the label is arbitrary, but the value should be changed for each workflow you run. *This is a workaround which will be fixed later - eventually it will be simpler, e.g. specify the workflow id instead*.


