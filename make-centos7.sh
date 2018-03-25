#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0);pwd)

docker-compose run --rm centos7 /share/make-env.sh
