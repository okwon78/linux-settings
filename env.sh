#!/bin/bash

alias ll='ls -lG'
alias mongod='mongod --dbpath=~/data/db'
alias redis-server='redis-server /usr/local/etc/redis.conf'

export PATH=$PATH:/Users/amore/anaconda3/bin
export PATH=$PATH:/usr/local/opt/ncurses/bin

source /Users/amore/anaconda3/etc/profile.d/conda.sh
conda activate test

export AIRFLOW_HOME=~/airflow
export SLUGIFY_USES_TEXT_UNIDECODE=yes

export SPARK_LOCAL_IP="127.0.0.1"
