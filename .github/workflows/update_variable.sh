#!/bin/bash

# Parameters
OWNER=$1
REPO=$2
PERSONAL_ACCESS_TOKEN=$3
VARIABLE_NAME=$4
VARIABLE_VALUE=$5

GITHUB_API_URL="https://api.github.com/repos/$OWNER/$REPO/actions/variables"
AUTH_HEADER="Authorization: Bearer $PERSONAL_ACCESS_TOKEN"
ACCEPT_HEADER="Accept: application/vnd.github+json"
API_VERSION_HEADER="X-GitHub-Api-Version: 2022-11-28"

VARIABLE_NAME="LAST_MODULAR_UPDATE_DATE"
VARIABLE_VALUE=$(date '+%Y-%m-%d %H:%M:%S')

response=$(curl -s -L -H "$AUTH_HEADER" -H "$ACCEPT_HEADER" -H "$API_VERSION_HEADER" "$GITHUB_API_URL/$VARIABLE_NAME")

if echo "$response" | grep -q '"message": "Not Found"'; then
    echo "Variable $VARIABLE_NAME not found. Creating..."
    curl -s -L -X POST -o /dev/null \
        -H "$AUTH_HEADER" \
        -H "$ACCEPT_HEADER" \
        -H "$API_VERSION_HEADER" \
        -d "{\"name\":\"$VARIABLE_NAME\",\"value\":\"$VARIABLE_VALUE\"}" \
        "$GITHUB_API_URL"
    echo "Variable $VARIABLE_NAME created successfully with value $VARIABLE_VALUE."
else
    echo "Variable $VARIABLE_NAME found. Updating..."
    curl -s -L -X PATCH  -o /dev/null \
        -H "$AUTH_HEADER" \
        -H "$ACCEPT_HEADER" \
        -H "$API_VERSION_HEADER" \
        -d "{\"name\":\"$VARIABLE_NAME\",\"value\":\"$VARIABLE_VALUE\"}" \
        "$GITHUB_API_URL/$VARIABLE_NAME"
    echo "Variable $VARIABLE_NAME updated successfully with value $VARIABLE_VALUE."
fi