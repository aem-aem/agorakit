#!/bin/sh

aws s3 sync /opt/agorakit/storage/app s3://$S3_BACKUP_BUCKET_NAME/app
aws s3 sync /opt/agorakit/storage/logs s3://$S3_BACKUP_BUCKET_NAME/logs
aws s3 cp /opt/agorakit/storage/dump.sql s3://$S3_BACKUP_BUCKET_NAME/

