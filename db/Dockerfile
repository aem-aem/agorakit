FROM mariadb
RUN apt-get update && apt-get install -y python3
COPY agorakit/reset_permissions.py agorakit/db_maintenance.sh /
RUN chmod a+x /db_maintenance.sh
