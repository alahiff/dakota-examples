# Parallel Dakota example
Example of running Dakota in parallel and having the analysis script launching the application in serial.

## Single node
```
prominence create --name dakota-parallelism \
                  --cpus 6 \
                  --artifact https://github.com/alahiff/dakota-examples/raw/master/text-book/dakota-text-book.tgz \
                  --workdir text_book \
                  alahiff/dakota \
                  "mpirun -np 6 dakota -i dakota_pstudy.in"
```

## Multiple nodes
```
prominence create --name dakota-parallelism \
                  --cpus 4 \
                  --nodes 4 \
                  --openmpi \
                  --artifact https://github.com/alahiff/dakota-examples/raw/master/text-book/dakota-text-book-2.tgz \
                  --workdir text_book \
                  alahiff/dakota \
                  "dakota -i dakota_pstudy.in"                  
```
