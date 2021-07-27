#!/bin/bash

minute=$(date '+%M')
hour=$(date '+%k')
day=$(date '+%w')
dayOfMonth=$(date '+%d')
dayOfMonthMod2=$(($dayOfMonth % 2))

MYSQL_OPTS="-u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE" 

#if [ $hour -eq 0 ] || [ $hour -eq 6 ] || [ $hour -eq 12 ]  || [ $hour -eq 18 ]; then
if [[ (( $hour -eq 0 || $hour -eq 6 || $hour -eq 12 || $hour -eq 18 )) && $minute -eq 0 ]]; then
	mysqldump $MYSQL_OPTS -C -r /tmp/storage/dump.sql
	mysql $MYSQL_OPTS -e "update membership set notification_interval = 1440; update groups set group_type=2; update membership set notification_interval=-1 where user_id<3;"
fi

mysql $MYSQL_OPTS -e "insert into actions select uniq+number, a.created_at, a.updated_at,deleted_at, a.group_id, a.user_id, a.name, a.body, a.start + interval 4*number week, a.stop + interval 4*number week, a.location, a.latitude, a.longitude from (select substring(regexp_replace(md5(concat(group_id, user_id, name)), '[a-z]', ''),1,6) as uniq, min(id) as id from actions where name like '\%[MENSUEL]' group by 1) seed, actions as a, range_6 where seed.id=a.id;"

mysql $MYSQL_OPTS -e "insert into actions select uniq+number, a.created_at, a.updated_at,deleted_at, a.group_id, a.user_id, a.name, a.body, a.start + interval number week, a.stop + interval number week, a.location, a.latitude, a.longitude from (select substring(regexp_replace(md5(concat(group_id, user_id, name)), '[a-z]', ''),1,6) as uniq, min(id) as id from actions where name like '\%[HEBDO]' group by 1) seed, actions as a, range_26 where seed.id=a.id;"

mysql $MYSQL_OPTS --skip-column-names -B -e "select distinct settings from groups;" | python3 /reset_permissions.py | mysql $MYSQL_OPTS
