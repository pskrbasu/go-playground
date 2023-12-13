#!/bin/sh

set -e

list=(
# "steampipe-plugin-aws"
# "steampipe-plugin-gcp"
# "steampipe-plugin-aiven"
# "steampipe-plugin-auth0"
# "steampipe-plugin-azuredevops"
# "steampipe-plugin-consul"
# "steampipe-plugin-crtsh"
"steampipe-plugin-databricks"
)

table_list=(
"aws_account:title"
"gcp_project:title"
"aiven_account:name"
"auth0_user:email"
"azuredevops_user:display_name"
"consul_key:title"
"crtsh_ca:name"
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
"scaleway_instance_image:name"
"snowflake_database:account"
"steampipe_registry_plugin:name"
"supabase_project:name"
"trello_board:name"
"twitter_user:name"
"uptimerobot_account:email"
"zoom_user:email"
)

# setup up a local postgres cluster
if [ -d "./pgdata" ]; then
  pg_ctl --pgdata ./pgdata --log ./logfile stop || true
  rm -rf ./pgdata
  rm -f logfile
fi
mkdir -p ./pgdata
# set a trap for a clean exit - even in failures
trap 'rm -rf ./pgdata' EXIT
pg_ctl --pgdata ./pgdata --log ./logfile initdb
pg_ctl --pgdata ./pgdata --log ./logfile start
pg_ctl --pgdata ./pgdata --log ./logfile stop

for item in "${list[@]}"; do
  # Extract the service name after the last hyphen
  plugin_name=${item##*-}
  echo ""
  echo ">>>>>>>>>>>>>>>>>>>>>>> Building plugin: ${plugin_name}"
  echo ""
  
  sqlite_build=""
  fdw_build=""

  # switch to the sqlite-extensions directory
  cd ../steampipe-sqlite-extension
  # Run the make command with the extracted plugin name
  if make build plugin="${plugin_name}"; then
  sqlite_build="success"
  fi
  # switch back directory
  cd -
  
  cd ../steampipe-postgres-fdw
  # Run the make command with the extracted plugin name
  if make standalone plugin="${plugin_name}"; then
  fdw_build="success"
  fi
  # switch back directory
  cd -
  
  # Check if a matching table and column were found
  if [ -z "$fdw_build" ] && [ -z "$sqlite_build" ]; then
    echo "######### Both builds failed for ${plugin_name}"
    continue
  fi

  if [ -z "$fdw_build" ]; then
    echo "######### FDW build failed for ${plugin_name}"
    continue
  fi
  if [ -z "$sqlite_build" ]; then
    echo "######### SQLite builds failed for ${plugin_name}"
    continue
  fi

  # Initialize variables
  matched_table=""
  matched_column=""

  # Find a matching table and column name
  for entry in "${table_list[@]}"; do
    if [[ $entry == ${plugin_name}* ]]; then
      matched_table=${entry%%:*}
      matched_column=${entry##*:}
      if [ "$matched_table" == "$matched_column" ]; then
        matched_column="title"
      fi
      break
    fi
  done

  # Check if a matching table and column were found
  if [ -z "$matched_table" ]; then
    echo "No matching table found for plugin ${plugin_name}"
    continue
  fi
  
  creds=""
  if [ -f "${plugin_name}_creds" ]; then
    creds="$(cat "${plugin_name}_creds")"
  else
    echo "Credentials file not found for plugin ${plugin_name}"
  fi
  
  if [ -n "$fdw_build" ]; then
    # install the FDW extension
    pg_ctl --pgdata ./pgdata --log ./logfile stop || true
    cd ../steampipe-postgres-fdw/build-Darwin
    chmod +x install.sh
    ./install.sh
    cd -

    # test the FDW extension
    pg_ctl --pgdata ./pgdata --log ./logfile start
    psql -d postgres -c "DROP EXTENSION IF EXISTS steampipe_postgres_${plugin_name} CASCADE;"
    psql -d postgres -c "CREATE EXTENSION IF NOT EXISTS steampipe_postgres_${plugin_name};"
    psql -d postgres -c "DROP SERVER IF EXISTS steampipe_${plugin_name};"
    if [ -n "$creds" ]; then
    psql -d postgres -c "CREATE SERVER steampipe_${plugin_name} FOREIGN DATA WRAPPER steampipe_postgres_${plugin_name} OPTIONS (config \"${creds}\");"
    else
    psql -d postgres -c "CREATE SERVER steampipe_${plugin_name} FOREIGN DATA WRAPPER steampipe_postgres_${plugin_name};"
    fi
    psql -d postgres -c "DROP SCHEMA IF EXISTS ${plugin_name} CASCADE;"
    psql -d postgres -c "CREATE SCHEMA ${plugin_name};"
    psql -d postgres -c "IMPORT FOREIGN SCHEMA ${plugin_name} FROM SERVER steampipe_${plugin_name} INTO ${plugin_name};" || true
    psql -d postgres -c "SELECT ${matched_column} FROM ${plugin_name}.${matched_table};" || true
    pg_ctl --pgdata ./pgdata --log ./logfile stop
  fi

  if [ -n "$sqlite_build" ]; then
    # test the sqlite3 extension
    if [ -n "$creds" ]; then
    ./sqlite3 -cmd ".load $(pwd)/../steampipe-sqlite-extension/steampipe_sqlite_${plugin_name}.so" -cmd ".headers on" -cmd ".mode json" :memory: "select steampipe_configure_${plugin_name}(readfile('${plugin_name}_creds'))" "select ${matched_column} from ${matched_table};" || true
    else
    ./sqlite3 -cmd ".load $(pwd)/../steampipe-sqlite-extension/steampipe_sqlite_${plugin_name}.so" -cmd ".headers on" -cmd ".mode json" :memory: "select ${matched_column} from ${matched_table};" || true
    fi
  fi
done