#!/bin/bash

failed=false

mkdir -p results

for problem in sql/*; do
    printf "$problem "
    problem_id=$(basename ${problem%.sql})
    result="results/$problem_id.out"
    expected="expected/$problem_id.out"

    # UPDATED LINE BELOW: Point psql to your Docker container!
    psql postgresql://postgres:pass@localhost:10002/postgres < $problem > $result

    DIFF=$(diff -B $expected $result)
    if [ -z "$DIFF" ]; then
        echo pass
    else
        echo fail
        failed=true
    fi
done

if [ "$failed" = "true" ]; then
    exit 2
fi
