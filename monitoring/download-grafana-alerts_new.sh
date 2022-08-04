#!/bin/sh

# ADDRESS has to be set
ALERTS_JSON_PATH=./alerts/alerts.json

curl -H "Authorization: Bearer ${GRAFANA_TOKEN}" $ADDRESS/api/ruler/grafana/api/v1/rules | jq > ${ALERTS_JSON_PATH}
