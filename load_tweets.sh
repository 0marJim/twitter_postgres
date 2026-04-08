#!/bin/sh

# list all of the files that will be loaded into the database
files='
test-data.zip
'

echo 'load normalized'
for file in $files; do
    # call the load_tweets.py file to load data into pg_normalized (Port 10002)
    python3 load_tweets.py --db=postgresql://postgres:pass@localhost:10002/postgres --inputs=$file
done

echo 'load denormalized'
for file in $files; do
    # use SQL's COPY command to load data into pg_denormalized (Port 10001)
    unzip -p $file | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:10001/postgres -c "COPY tweets FROM STDIN csv quote e'\x01' delimiter e'\x02';"
done
