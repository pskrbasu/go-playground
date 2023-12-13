#!/usr/bin/env bash

set -e

list=(
  "steampipe-plugin-aws"
)

for item in "${list[@]}"; do
  # Extract the last word after the last hyphen
  plugin_name=${item##*-}
  echo ""
  echo "Building plugin: ${plugin_name}"
  echo ""

  # switch to the sqlite-extensions directory
  cd /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension
  # Run the make command with the extracted plugin name
  make build plugin="${plugin_name}"

  # switch to the local sqlite directory for testing
  cd /Users/pskrbasu/sqlite

  # run the sqlite3 command with the extension
  ./sqlite3_darwin_arm64 -cmd ".load /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension/steampipe_sqlite_aws.so" -cmd ".headers on" -cmd ".mode json" :memory: "select steampipe_configure_aws(readfile('aws_creds'))" "select instance_id, monitoring_state from aws_ec2_instance where monitoring_state = 'disabled';" | jq

  ./sqlite3_darwin_arm64 -cmd ".load /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension/steampipe_sqlite_aws.so" -cmd ".headers on" -cmd ".mode json" :memory: "select steampipe_configure_aws(readfile('aws_creds'))" "select instance_id, instance_state, launch_time, state_transition_time from aws_ec2_instance where instance_state = 'stopped' limit 2;" | jq

  ./sqlite3_darwin_arm64 -cmd ".load /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension/steampipe_sqlite_aws.so" -cmd ".headers on" -cmd ".mode json" :memory: "select steampipe_configure_aws(readfile('aws_creds'))" "select i.instance_id, json_extract(vols.value, '$.Ebs.VolumeId') as vol_id, vol.encrypted from aws_ec2_instance as i, json_each(i.block_device_mappings) as vols join aws_ebs_volume as vol on vol.volume_id = json_extract(vols.value, '$.Ebs.VolumeId') where not vol.encrypted;" | jq

  ./sqlite3_darwin_arm64 -cmd ".load /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension/steampipe_sqlite_aws.so" -cmd ".headers on" -cmd ".mode json" :memory: "select steampipe_configure_aws(readfile('aws_creds'))" "select instance_type, count(*) as count from aws_ec2_instance where instance_type not in ('t2.large', 'm3.medium') group by instance_type;" | jq

  ./sqlite3_darwin_arm64 -cmd ".load /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension/steampipe_sqlite_aws.so" -cmd ".headers on" -cmd ".mode json" :memory: "select steampipe_configure_aws(readfile('aws_creds'))" "select instance_type, count(instance_type) as count from aws_ec2_instance group by instance_type;" | jq

  ./sqlite3_darwin_arm64 -cmd ".load /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension/steampipe_sqlite_aws.so" -cmd ".headers on" -cmd ".mode json" :memory: "select steampipe_configure_aws(readfile('aws_creds'))" "select instance_id, tags from aws_ec2_instance where json_extract(tags, '$.application') is null;" | jq

  ./sqlite3_darwin_arm64 -cmd ".load /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension/steampipe_sqlite_aws.so" -cmd ".headers on" -cmd ".mode json" :memory: "select steampipe_configure_aws(readfile('aws_creds'))" "select instance_id, instance_state, launch_time, state_transition_time from aws_ec2_instance where instance_state = 'stopped' and state_transition_time <= date('now', '-30 day');" | jq


done

