#!/usr/bin/env bash

set -e

 list=("steampipe-plugin-abuseipdb"
   "steampipe-plugin-aiven"
   "steampipe-plugin-algolia"
   "steampipe-plugin-alicloud"
   "steampipe-plugin-ansible"
   "steampipe-plugin-auth0"
   "steampipe-plugin-aws"
   "steampipe-plugin-awscfn"
   "steampipe-plugin-azure"
   "steampipe-plugin-azuread"
   "steampipe-plugin-azuredevops"
   "steampipe-plugin-bitbucket"
   "steampipe-plugin-buildkite"
   "steampipe-plugin-chaos"
   "steampipe-plugin-chaosdynamic"
   "steampipe-plugin-circleci"
   "steampipe-plugin-cloudflare"
   "steampipe-plugin-code"
   "steampipe-plugin-config" # did not build
   "steampipe-plugin-consul"
   "steampipe-plugin-crowdstrike"
   "steampipe-plugin-crtsh"
   "steampipe-plugin-csv"
   "steampipe-plugin-databricks"
   "steampipe-plugin-datadog"
   "steampipe-plugin-digitalocean"
   "steampipe-plugin-docker"
   "steampipe-plugin-dockerhub"
   "steampipe-plugin-doppler"
   "steampipe-plugin-duo"
   "steampipe-plugin-env0"
   "steampipe-plugin-equinix"
   "steampipe-plugin-exec"
   "steampipe-plugin-fastly"
   "steampipe-plugin-finance" # did not build
   "steampipe-plugin-fly"
   "steampipe-plugin-gcp"
   "steampipe-plugin-github"
  "steampipe-plugin-godaddy"
   "steampipe-plugin-googledirectory"
   "steampipe-plugin-googlesheets"
   "steampipe-plugin-googleworkspace"
   "steampipe-plugin-grafana"
   "steampipe-plugin-guardrails"
   "steampipe-plugin-hackernews"
   "steampipe-plugin-hcloud"
   "steampipe-plugin-heroku"
   "steampipe-plugin-hibp" # did not build
   "steampipe-plugin-hypothesis"
   "steampipe-plugin-ibm"
   "steampipe-plugin-imap"
   "steampipe-plugin-ipinfo"
   "steampipe-plugin-ipstack"
   "steampipe-plugin-jenkins"
   "steampipe-plugin-jira"
   "steampipe-plugin-jumpcloud"
   "steampipe-plugin-kubernetes" # did not build
   "steampipe-plugin-launchdarkly"
   "steampipe-plugin-ldap"
   "steampipe-plugin-linear"
   "steampipe-plugin-linkedin"
   "steampipe-plugin-linode"
   "steampipe-plugin-mailchimp"
   "steampipe-plugin-mastodon"
   "steampipe-plugin-microsoft365"
   "steampipe-plugin-mongodbatlas"
   "steampipe-plugin-namecheap"
   "steampipe-plugin-net"
   "steampipe-plugin-newrelic"
   "steampipe-plugin-nomad" # did not build
   "steampipe-plugin-oci"
   "steampipe-plugin-okta"
   "steampipe-plugin-onepassword"
   "steampipe-plugin-openai"
   "steampipe-plugin-openapi"
   "steampipe-plugin-pagerduty"
   "steampipe-plugin-panos"
   "steampipe-plugin-planetscale"
   "steampipe-plugin-prometheus"
   "steampipe-plugin-reddit" # did not build
   "steampipe-plugin-rss"
   "steampipe-plugin-salesforce"
   "steampipe-plugin-scaleway"
   "steampipe-plugin-sentry"
   "steampipe-plugin-servicenow"
   "steampipe-plugin-shodan"
   "steampipe-plugin-shopify"
   "steampipe-plugin-slack"
   "steampipe-plugin-snowflake"
   "steampipe-plugin-splunk"
   "steampipe-plugin-steampipe"
   "steampipe-plugin-stripe"
   "steampipe-plugin-supabase"
   "steampipe-plugin-tailscale"
   "steampipe-plugin-terraform"
   "steampipe-plugin-tfe"
   "steampipe-plugin-trello"
   "steampipe-plugin-trivy"
   "steampipe-plugin-twilio"
   "steampipe-plugin-twitter"
   "steampipe-plugin-updown"
   "steampipe-plugin-uptimerobot"
   "steampipe-plugin-urlscan" # did not build
   "steampipe-plugin-vanta"
   "steampipe-plugin-vercel" # did not build
   "steampipe-plugin-virustotal"
   "steampipe-plugin-whois"
   "steampipe-plugin-wiz"
   "steampipe-plugin-workos"
   "steampipe-plugin-zendesk"
   "steampipe-plugin-zoom" 
   "steampipe-plugin-pipes"
   "steampipe-plugin-openshift"
   "steampipe-plugin-hubspot"
)

# for item in "${list[@]}"; do
#   # Extract the last word after the last hyphen
#   plugin_name=${item##*-}
#   echo ""
#   echo "Building plugin: ${plugin_name}"
#   echo ""
  
#   # switch to the fdw directory
#   cd /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-postgres-fdw-anywhere
#   # Run the make command with the extracted plugin name
#   make standalone plugin="${plugin_name}"
#   # switch to the directory containing the binaries
#   cd build-Darwin
#   # Copy the binaries to the right locations
#   ./install.sh
#   cd -
# done

for item in "${list[@]}"; do
    # Extract the last word after the last hyphen
    plugin_name=${item##*-}
    echo ""
    echo "Building plugin: ${plugin_name}"
    echo ""
    
    # Switch to the fdw directory
    cd /Users/pskrbasu/turbot-delivery/Steampipe/steampipe-table-dump
    
    # Run the make command with the extracted plugin name
    if make build plugin="${plugin_name}"; then
        # If make command is successful
        echo "Successfully built plugin: ${plugin_name}"
        cd -
    else
        # If make command fails, write the plugin name to a file
        echo "${plugin_name}" >> failed_plugins.txt
        cd -
    fi
done