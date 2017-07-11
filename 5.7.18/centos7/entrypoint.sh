#!/bin/bash

function initialize() {
if [[ ! -d ${MYSQL_DATA_DIR} ]]; then
	mkdir -p ${MYSQL_DATA_DIR}
fi

if [[ ! "$(ls -A ${MYSQL_DATA_DIR})" ]]; then
	echo "Initializing MySQL"
	MYSQLD_INITIALIZE_ARGS+="--initialize-insecure "
	MYSQLD_INITIALIZE_ARGS+="--basedir=${MYSQL_HOME} "
	MYSQLD_INITIALIZE_ARGS+="--datadir=${MYSQL_DATA_DIR}"
	mysqld ${MYSQLD_INITIALIZE_ARGS}
fi
}

function start() {
	MYSQLD_ARGS+="--basedir=${MYSQL_HOME} "
	MYSQLD_ARGS+="--datadir=${MYSQL_DATA_DIR}"
	mysqld ${MYSQLD_ARGS} &
	export MYSQL_PID=$!
}

function end() {
kill -9 ${MYSQL_PID}
}


initialize
trap end EXIT
start
wait ${MYSQL_PID}
