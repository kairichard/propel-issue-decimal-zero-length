SHELL=/bin/bash
.PHONY: init test

MYSQL_USER?=root
MYSQL_PW?=root
MYSQL_HOST?=localhost
MYSQL_DATABASE?=propel
PROPEL_VERSION?=~2.0@dev

ENV=MYSQL_PW=${MYSQL_PW} MYSQL_USER=${MYSQL_USER} MYSQL_DATABASE=${MYSQL_DATABASE} MYSQL_HOST=${MYSQL_HOST}

PROPEL_CMD=${ENV} vendor/bin/propel
MYSQL_CMD=mysql -p${MYSQL_PW} -u${MYSQL_USER} -h ${MYSQL_HOST}

FAILURE_MSG='Two migration have been created'


clean:
	-rm -rf generated-reversed-database migrations
	-rm -rf vendor

init:
	php composer.phar require propel/propel:${PROPEL_VERSION}
	echo "DROP DATABASE IF EXISTS ${MYSQL_DATABASE};CREATE DATABASE ${MYSQL_DATABASE};" | ${MYSQL_CMD}
	cat create-table.sql | ${MYSQL_CMD} ${MYSQL_DATABASE}

migrations: clean init
	${PROPEL_CMD} reverse
	echo "DROP DATABASE propel;CREATE DATABASE propel;" | ${MYSQL_CMD}
	${PROPEL_CMD} diff
	${PROPEL_CMD} migrate
	sleep 1 # this is needed because of the timestamp in the filename of the migration file
	${PROPEL_CMD} diff

test: migrations
	test 1 -eq `find generated-migrations -maxdepth 1 -type f|wc -l` || echo '${FAILURE_MSG}' && exit 1

