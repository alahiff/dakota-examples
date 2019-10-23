# JOREK parameter scan + Dakota optimise

## Submitting the workflow
The full parameter scan with optimisation for each parameter set can be submitted in the following way:
```
$ prominence run jorek-sweep-opt-2.json
Workflow created with id 25335
```
To check the status, run:
```
$ prominence list workflows
ID      NAME                             CREATED               STATUS    ELAPSED      PROGRESS
25335   jorek-sweep-optimise-with-data   2019-10-23 10:42:09   running   0+00:02:49   0/9
```
The following command can be run to see the individual jobs which have been created:
```
$ prominence list
ID      NAME                                                     CREATED               STATUS      ELAPSED      IMAGE               CMD                                                               
25336   jorek-sweep-optimise-with-data/dakota-jorek-optimise/0   2019-10-23 10:42:14   completed   0+00:14:07   jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25337   jorek-sweep-optimise-with-data/dakota-jorek-optimise/1   2019-10-23 10:42:14   running     0+00:20:04   jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25338   jorek-sweep-optimise-with-data/dakota-jorek-optimise/2   2019-10-23 10:42:16   running     0+00:22:04   jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25339   jorek-sweep-optimise-with-data/dakota-jorek-optimise/3   2019-10-23 10:42:16   running     0+00:24:04   jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25340   jorek-sweep-optimise-with-data/dakota-jorek-optimise/4   2019-10-23 10:42:18   running     0+00:23:04   jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25341   jorek-sweep-optimise-with-data/dakota-jorek-optimise/5   2019-10-23 10:42:18   running     0+00:14:04   jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25344   jorek-sweep-optimise-with-data/dakota-jorek-optimise/6   2019-10-23 10:42:20   running     0+00:20:04   jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25345   jorek-sweep-optimise-with-data/dakota-jorek-optimise/7   2019-10-23 10:42:20   running     0+00:13:04   jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
25348   jorek-sweep-optimise-with-data/dakota-jorek-optimise/8   2019-10-23 10:42:22   running     0+00:18:04   jorek-dakota.simg   /usr/local/bin/generate-jorek-input.perl $x1 $x2 injt60sa.template
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
25335   jorek-sweep-optimise-with-data   2019-10-23 10:42:09   running   0+00:42:28   5/9
```
When the workflow has completed it will no longer be visible when you run `prominence list workflows`, i.e.
```
$ prominence list workflows
ID   NAME   CREATED               STATUS   ELAPSED      PROGRESS
```
If you add the `--completed` option you will be able to see the status:
```
$ prominence list workflows --completed
ID      NAME                             CREATED               STATUS      ELAPSED      PROGRESS
25313   jorek-sweep-optimise-with-data   2019-10-23 06:19:01   completed   0+02:26:03   9/9
```

Once the workflow has completed, the script `get-all-outputs` can be used to download all
```
python get-all-outputs thing=6C5B8EFB
```
This script will create a unique directory for each job and download the output tarball from ECHO. Here `thing=6C5B8EFB` is a constraint on the jobs, i.e. it will find all jobs which have a label `thing` with value `6C5B8EFB`. If you look at the file `jorek-sweep-opt-2.json` you can see this defined. Note that the label is arbitrary, but the value should be changed for each workflow you run. *This is a workaround which will be fixed later - eventually it will be simpler, e.g. specify the workflow id instead*.


