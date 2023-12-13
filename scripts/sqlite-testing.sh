#!/bin/sh

set -e

list=(
  "steampipe-plugin-aws"
  "steampipe-plugin-gcp"
  "steampipe-plugin-aiven"
  "steampipe-plugin-auth0"
  "steampipe-plugin-azuredevops"
  "steampipe-plugin-consul"
  # "steampipe-plugin-crtsh"
  "steampipe-plugin-databricks"
  "steampipe-plugin-equinix"
  "steampipe-plugin-ibm"
  "steampipe-plugin-imap"
  "steampipe-plugin-launchdarkly"
  "steampipe-plugin-jumpcloud"
  "steampipe-plugin-linkedin"
  "steampipe-plugin-mailchimp"
  "steampipe-plugin-mongodbatlas"
  "steampipe-plugin-salesforce"
  # "steampipe-plugin-scaleway"
  "steampipe-plugin-snowflake"
  "steampipe-plugin-steampipe"
  "steampipe-plugin-supabase"
  "steampipe-plugin-trello"
  "steampipe-plugin-twitter"
  "steampipe-plugin-uptimerobot"
  "steampipe-plugin-zoom"
)

table_list=(
"aws_account"
"gcp_project:title"
"aiven_account:name"
"auth0_user:email"
"azuredevops_user:display_name"
"consul_key:title"
# "crtsh_ca:name"
"databricks_workspace:title"
"equinix_metal_project:name"
"ibm_account:name"
"imap_mailbox:name"
"launchdarkly_team:name"
"jumpcloud_user:email"
"linkedin_profile:last_name"
"mailchimp_list:name"
"mongodbatlas_org:title"
"salesforce_account:id"
# "scaleway_instance_image:name"
"snowflake_database:account"
"steampipe_registry_plugin:name"
"supabase_project:name"
"trello_board:name"
"twitter_user:name"
"uptimerobot_account:email"
"zoom_user:email"
)

for item in "${list[@]}"; do
  # Extract the service name after the last hyphen
  plugin_name=${item##*-}
  echo ""
  echo "Building plugin: ${plugin_name}"
  echo ""

  # switch to the sqlite-extensions directory
  cd /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension
  # Run the make command with the extracted plugin name
  make build plugin="${plugin_name}"

  # Initialize variables
  matched_table=""
  matched_column=""

  # Find a matching table and column name
  for entry in "${table_list[@]}"; do
    if [[ $entry == ${plugin_name}* ]]; then
      matched_table=${entry%%:*}
      matched_column=${entry##*:}

      # If no column name is passed, default to 'title'
      if [ "$matched_table" == "$matched_column" ]; then
        matched_column="title"
      fi

      break
    fi
  done

  # Check if a matching table was found
  if [ -z "$matched_table" ]; then
    echo "No matching table found for plugin ${plugin_name}"
    continue
  fi

  # switch to the local sqlite directory for testing
  cd /Users/pskrbasu/sqlite

  # run the sqlite3 command with the extension, matched table and column
  ./sqlite3 -cmd ".load /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension/steampipe_sqlite_${plugin_name}.so" -cmd ".headers on" -cmd ".mode json" :memory: "select steampipe_configure_${plugin_name}(readfile('${plugin_name}_creds'))" "select ${matched_column} from ${matched_table};" | jq

done
