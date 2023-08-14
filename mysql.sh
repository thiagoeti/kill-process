#!/bin/sh

#-- ----- ----- -----

echo -e "KILL Process - MySQL - $(date)"

#-- ----- ----- -----

# config

host="127.0.0.1"
user="root"
passwd="master"

max=60*5 # 5min

#-- ----- ----- -----

queries=$(mysql -h"$host" -u"$user" -p"$passwd" "information_schema" -se "SELECT CONCAT('KILL ', id, ';') FROM information_schema.processlist WHERE TIME>=$max;")

echo -e "$queries"

result=$(mysql -h"$host" -u"$user" -p"$passwd" "information_schema" -se "$queries")

#-- ----- ----- -----

exit $?
