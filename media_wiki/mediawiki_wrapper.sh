#!/bin/bash
#2016 01 04 T Glynn

# Kicks off a mediawiki sqldump and xml dump, then scp's that dump back to the local machine


# Variables

# Overwrite variables, or source in ENV

remote_user=$REMOTE_USER
remote_host=$REMOTE_HOST
remote_backup_dir=$REMOTE_BACKUP_DIR
local_backup_dir=$LOCAL_BACKUP_DIR
local_log_dir=$LOCAL_LOG_DIR

ssh $remote_user@$remote_host "/usr/local/bin/mediawiki_backup.sh" 
if [[ $? -ne 0 ]]; then
    echo $(date): mediawiki script failed >> $local_log_dir/mediawikibackup.err
    exit 1
fi

mkdir $local_backup_dir/$(date +%Y%m%d)/

scp $remote_user@$remote_host:$remote_backup_dir/$(date +%Y%m%d)/backup.sql.gz \
    $local_backup_dir/$(date +%Y%m%d)/

error_count=0

if [[ $? -ne 0 ]]; then
    echo $(date): Could not scp backup.sql.gz >> $local_log_dir/mediawikibackup.err
    error_count=$((error_count + 1))
fi

scp $remote_user@$remote_host:$remote_backup_dir/$(date +%Y%m%d)/dump.xml.gz \
    $local_backup_dir/$(date +%Y%m%d)/

if [[ $? -ne 0 ]]; then
    echo $(date): Could not scp dump.xml.gz >> $local_log_dir/mediawikibackup.err
    error_count=$((error_count + 1))
fi

if [[ $error_count -gt 0 ]]; then
    echo $(date): Exiting with errors >> $local_log_dir/mediawikibackup.err
    exit 1
fi

exit 0
