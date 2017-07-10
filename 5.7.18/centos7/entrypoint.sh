#!/bin/bash

if [[ ! -d ${MYSQL_DATA_DIR} ]]; then
	mkdir -p ${MYSQL_DATA_DIR}
fi

if [[ ! "$(ls -A ${MYSQL_DATA_DIR})" ]]; then
	mysqld --initialize-insecure --datadir=${MYSQL_DATA_DIR} --user=${MYSQL_USERNAME}
fi

mysqld
MYSQL_PID=$!

trap kill -9 ${MYSQL_PID}
wait ${MYSQL_PID}
