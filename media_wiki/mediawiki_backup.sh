#!/bin/bash
# 2016 01 04 T Glynn

# Create backup directory, dump mediawiki mysql database

# Variables

## Note - source environment file with secrets, or edit this script with real
# values
wiki_backup_dir=$WIKI_BACKUP_DIR
backup_log_dir=$BACKUP_LOG_DIR
mysql_user=$MYSQL_USER
mysql_pass=$MYSQL_PASS
mysql_host=$MYSQL_HOST


#Make the backup dir
mkdir $wiki_backup_dir/$(date +%Y%m%d)/
if [[ $? -ne 0 ]]; then
    echo $(date): Unable to make backup dir.  Quitting >> $backup_log_dir/backup.log
    exit 1
fi

#Dump mysql database
mysqldump -h $mysql_host -u $mysql_user --password=$mysql_pass \
    --default-character-set=binary wiki | gzip > \
    $wiki_backup_dir/$(date +%Y%m%d)/backup.sql.gz

if [[ $? -ne 0 ]]; then
	echo $(date): Backup failed >> $backup_log_dir/backup.log
	exit 1
else
	echo $(date): Backup succeeded >> $backup_log_dir/backup.log
	exit 0
fi
