#!/bin/bash

minute=$(date '+%M')
minute=${minute#0}
hour=$(date '+%k')
hour=${hour#0}
day=$(date '+%w')
dayOfMonth=$(date '+%d')
dayOfMonthMod2=$((${dayOfMonth#0} % 2))

MYSQL_OPTS="-u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE" 

#if [ $hour -eq 0 ] || [ $hour -eq 6 ] || [ $hour -eq 12 ]  || [ $hour -eq 18 ]; then
if [[ (( $hour -eq 0 || $hour -eq 6 || $hour -eq 12 || $hour -eq 18 )) && $minute -eq 0 ]]; then
	mysqldump $MYSQL_OPTS -C -r /tmp/storage/dump.sql
	mysql $MYSQL_OPTS -e "update membership set notification_interval = 1440; update groups set group_type=1; update membership set notification_interval=-1 where user_id<3;"
fi

for freq in "HEBDO" "MENSUEL"; do
	mysql $MYSQL_OPTS -e "insert into actions (created_at, updated_at, deleted_at, group_id, user_id, name, body, start, stop, location, latitude, longitude) select a.created_at, a.updated_at, a.deleted_at, a.group_id, a.user_id, a.name, concat('[COPY]<br><br>', a.body), a.start + interval number week, a.stop + interval number week, a.location, a.latitude, a.longitude from (select created_at, group_id, name, user_id, min(id) as id from actions where name like '%["$freq"]' and body not like '[COPY]%' group by 1) seed, actions as a, weeks where seed.created_at + interval 5 minute >= now() and seed.id=a.id and weeks.freq='"$freq"';"
done

mysql $MYSQL_OPTS --skip-column-names -B -e "select distinct settings from groups;" | python3 /reset_permissions.py | mysql $MYSQL_OPTS
