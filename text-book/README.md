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

```
