#!/bin/bash

# A simple example script that publishes a number of scripts to the Nexus Repository Manager
# and executes them.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

username=admin
password=admin123

# add the context if you are not using the root context
#nexus resolves to the service nexus in the current namespace
host="http://nexus:8081"

response=$(curl -Is $host | head -1 | awk '{ print $2 }')

while [[ -z $response ]]; do
  sleep 15
  response=$(curl -Is $host | head -1 | awk '{ print $2 }')
done

response=$(curl -u $username:$password -Is $host/service/metrics/ping | head -1 | awk '{ print $2 }')

if [[ $response -eq 401 ]]; then
  username="$NEXUS_ADMIN_USERNAME"
  password="$NEXUS_ADMIN_PASSWORD"
fi

# add a script to the repository manager and run it
function addAndRunScriptAdminUser {
  name=$1
  file=$2
  # using grape config that points to local Maven repo and Central Repository , default grape config fails on some downloads although artifacts are in Central
  # change the grapeConfig file to point to your repository manager, if you are already running one in your organization
  groovy -Dgroovy.grape.report.downloads=true -Dgrape.config=grapeConfig.xml addUpdateScript.groovy -u "$username" -p "$password" -n "$name" -f "$file" -h "$host"
  printf "\nPublished $file as $name\n\n"
  curl -v -X POST -u $username:$password --header "Content-Type: text/plain" "$host/service/siesta/rest/v1/script/$name/run" -d "{ \"name\": \"$NEXUS_ADMIN_USERNAME\", \"password\": \"$NEXUS_ADMIN_PASSWORD\", \"email\": \"$NEXUS_ADMIN_EMAIL\", \"fname\": \"$NEXUS_ADMIN_FNAME\", \"lname\": \"$NEXUS_ADMIN_LNAME\" }"
  printf "\nSuccessfully executed $name script\n\n\n"
}

function addAndRunScript {
  name=$1
  file=$2
  # using grape config that points to local Maven repo and Central Repository , default grape config fails on some downloads although artifacts are in Central
  # change the grapeConfig file to point to your repository manager, if you are already running one in your organization
  groovy -Dgroovy.grape.report.downloads=true -Dgrape.config=grapeConfig.xml addUpdateScript.groovy -u "$username" -p "$password" -n "$name" -f "$file" -h "$host"
  printf "\nPublished $file as $name\n\n"
  curl -v -X POST -u $username:$password --header "Content-Type: text/plain" "$host/service/siesta/rest/v1/script/$name/run"
  printf "\nSuccessfully executed $name script\n\n\n"
}

printf "Provisioning Integration API Scripts Starting \n\n" 
printf "Publishing and executing on $host\n"

addAndRunScriptAdminUser addAdmin addAdmin.groovy
addAndRunScript checkExists checkExists.groovy
#switch to new admin user if not already
username="$NEXUS_ADMIN_USERNAME"
password="$NEXUS_ADMIN_PASSWORD"
addAndRunScript security security.groovy

printf "\nProvisioning Scripts Completed\n\n"
