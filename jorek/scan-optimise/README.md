# JOREK parameter scan + Dakota optimise

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
Each job will create a tarball containing:
* dakota_jorek.out
* dakota_jorek.dat
* all the work directories created by Dakota

which will be automatically uploaded to ECHO as each job completed.
