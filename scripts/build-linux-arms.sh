#!/bin/sh

set -e

list=(
# "steampipe-plugin-updown"
# "steampipe-plugin-twilio"
# "steampipe-plugin-tfe"
# "steampipe-plugin-stripe"
# "steampipe-plugin-splunk"
# "steampipe-plugin-vanta"
# "steampipe-plugin-servicenow"
# "steampipe-plugin-rss"
# "steampipe-plugin-prometheus"
# "steampipe-plugin-planetscale"
# "steampipe-plugin-namecheap"
# "steampipe-plugin-jenkins"
# "steampipe-plugin-ipinfo"
# "steampipe-plugin-hackernews"
# "steampipe-plugin-grafana"
# "steampipe-plugin-net"
# "steampipe-plugin-nomad"
# "steampipe-plugin-linear"
# "steampipe-plugin-linode"
# "steampipe-plugin-ipstack"
# "steampipe-plugin-shopify"
# "steampipe-plugin-shodan"
# "steampipe-plugin-openai"
# "steampipe-plugin-openapi"
# "steampipe-plugin-newrelic"
# "steampipe-plugin-panos"
# "steampipe-plugin-pagerduty"


# "steampipe-plugin-ansible"
# "steampipe-plugin-awscfn"
# "steampipe-plugin-ldap"
# "steampipe-plugin-openapi"
# "steampipe-plugin-prometheus"
# "steampipe-plugin-terraform"

# "steampipe-plugin-godaddy"
# "steampipe-plugin-googledirectory..."
# "steampipe-plugin-googlesheets"
# "steampipe-plugin-googleworkspace"
# "steampipe-plugin-guardrails"
# "steampipe-plugin-hackernews"
# "steampipe-plugin-hcloud"
# "steampipe-plugin-heroku"
# "steampipe-plugin-hibp"
# "steampipe-plugin-hypothesis"
# "steampipe-plugin-kubernetes..."
# "steampipe-plugin-mastodon"
# "steampipe-plugin-microsoft365"
# "steampipe-plugin-oci"
# "steampipe-plugin-openshift"
# "steampipe-plugin-pipes"
# "steampipe-plugin-reddit"
# "steampipe-plugin-trivy..."
# "steampipe-plugin-urlscan"
# "steampipe-plugin-vercel"
# "steampipe-plugin-cloudflare"
# "steampipe-plugin-code"
# "steampipe-plugin-config..."
# "steampipe-plugin-exec"
# "steampipe-plugin-googledirectory"
# "steampipe-plugin-azure"
# "steampipe-plugin-chaosdynamic"
# "steampipe-plugin-config"
"steampipe-plugin-chaos"
)

if [[ ! ${MY_PATH} ]];
then
  MY_PATH="`dirname \"$0\"`"              # relative
  MY_PATH="`( cd \"$MY_PATH\" && pwd )`"  # absolutized and normalized
fi

echo $MY_PATH

mkdir $MY_PATH/go-cache || true
mkdir $MY_PATH/go-mod-cache || true

GOCACHE=$(docker run --memory="10g" --memory-swap="16g" --rm --name sp_fdw_builder steampipe_fdw_builder:15 go env GOCACHE)
MODCACHE=$(docker run --memory="10g" --memory-swap="16g" --rm --name sp_fdw_builder steampipe_fdw_builder:15 go env GOMODCACHE)


for item in "${list[@]}"; do
  # Extract the plugin name (last word after the hyphen)
  plugin_name=${item##*-}

  echo "Processing plugin: ${plugin_name}"

  # Step 1: Switch to steampipe-postgres-fdw directory
  cd /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-postgres-fdw || exit 1

  # Step 2: Run Docker commands for Postgres FDW Builder v15
  echo "Building Postgres FDW 15 for plugin: ${plugin_name}"
  docker run --memory="10g" --memory-swap="16g" --rm --name sp_fdw_builder -v "$(pwd)":/tmp/ext steampipe_fdw_builder:15 make clean
  docker run --memory="10g" --memory-swap="16g" --rm --name sp_fdw_builder -v "$(pwd)":/tmp/ext steampipe_fdw_builder:15 make standalone plugin="${plugin_name}"

  # Step 3: Check if build-Linux directory is created
  if [ ! -d "build-Linux" ] || [ ! -f "build-Linux/steampipe_postgres_${plugin_name}.so" ]; then
    echo "Error: build-Linux directory or steampipe_postgres_${plugin_name}.so not found."
    exit 1
  fi

  # Step 4: Move and tar for Postgres v15
  echo "Move and tar for Postgres v15 for plugin: ${plugin_name}"
  mv build-Linux steampipe_postgres_${plugin_name}.pg15.linux_arm64
  tar -czvf steampipe_postgres_${plugin_name}.pg15.linux_arm64.tar.gz steampipe_postgres_${plugin_name}.pg15.linux_arm64

  # Step 5: Check if tar.gz file is created for v15
  if [ ! -f "steampipe_postgres_${plugin_name}.pg15.linux_arm64.tar.gz" ]; then
    echo "Error: Tar file for Postgres v15 not created."
    exit 1
  fi

  # Step 6: Run Docker commands for Postgres FDW Builder v14
  echo "Building Postgres FDW 14 for plugin: ${plugin_name}"
  docker run --memory="10g" --memory-swap="16g" --rm --name sp_fdw_builder -v "$(pwd)":/tmp/ext steampipe_fdw_builder:14 make clean
  docker run --memory="10g" --memory-swap="16g" --rm --name sp_fdw_builder -v "$(pwd)":/tmp/ext steampipe_fdw_builder:14 make standalone plugin="${plugin_name}"

  # Step 7: Check if build-Linux directory is created for v14
  if [ ! -d "build-Linux" ] || [ ! -f "build-Linux/steampipe_postgres_${plugin_name}.so" ]; then
    echo "Error: build-Linux directory or steampipe_postgres_${plugin_name}.so not found for Postgres v14."
    exit 1
  fi

  # Step 8: Move and tar for Postgres v14
  echo "Move and tar for Postgres v14 for plugin: ${plugin_name}"
  mv build-Linux steampipe_postgres_${plugin_name}.pg14.linux_arm64
  tar -czvf steampipe_postgres_${plugin_name}.pg14.linux_arm64.tar.gz steampipe_postgres_${plugin_name}.pg14.linux_arm64

  # Step 9: Check if tar.gz file is created for v14
  if [ ! -f "steampipe_postgres_${plugin_name}.pg14.linux_arm64.tar.gz" ]; then
    echo "Error: Tar file for Postgres v14 not created."
    exit 1
  fi

  # Step 10: Switch to steampipe-sqlite-extension directory
  cd /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-sqlite-extension || exit 1

  # Step 11: Run Docker commands for SQLite Builder
  docker run --memory="10g" --memory-swap="16g" --rm --name sp_sqlite_builder -v "$(pwd)":/tmp/ext steampipe_qlite_builder make build plugin="${plugin_name}"

  # Step 12: Tar the SQLite extension
  tar -czvf steampipe_sqlite_${plugin_name}.linux_arm64.tar.gz steampipe_sqlite_${plugin_name}.so

  # Final Check: If SQLite tar.gz file is created
  if [ ! -f "steampipe_sqlite_${plugin_name}.linux_arm64.tar.gz" ]; then
    echo "Error: Tar file for SQLite not created."
    exit 1
  fi

  echo "Processing completed for plugin: ${plugin_name}"
done

echo "All plugins processed successfully."
