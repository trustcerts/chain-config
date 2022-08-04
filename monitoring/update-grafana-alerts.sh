#!/bin/sh

# ADDRESS and GRAFANA_TOKEN have to be set
ALERTS_JSON_PATH=./alerts/alerts.json
ALERTS_DEL_JSON_PATH=./alerts/alerts_object.json
FOLDERS=$(jq 'keys' ${ALERTS_JSON_PATH})

# Strip of "[" and "]"
FOLDERS=${FOLDERS:1}
FOLDERS=${FOLDERS:0:(`expr "$FOLDERS" : '.*'`)-2}
# Add "," so each element is the same
FOLDERS=$(echo $FOLDERS",")

# Turn into bash array
TEST=($FOLDERS)

for FOLDER_NAME in $FOLDERS
do
  # Remove the tailing "," and both " 
  FOLDER_NAME=${FOLDER_NAME:1:(`expr "$FOLDER_NAME" : '.*'`)-3}
  
  NUMBER_OF_ALERTS=$(jq -c --arg FOLDER_NAME "$FOLDER_NAME" '.[$FOLDER_NAME] | length' ${ALERTS_JSON_PATH})
  for ((i=0; i<NUMBER_OF_ALERTS; i++)); do
    NUMBER_OF_RULES=$(jq -c --arg i "$i" --arg FOLDER_NAME "$FOLDER_NAME" '(.[$FOLDER_NAME][($i | tonumber)].rules | length)' ${ALERTS_JSON_PATH})

    ALERT_OBJECT=$(jq -c --arg i "$i" --arg FOLDER_NAME "$FOLDER_NAME" '(.[$FOLDER_NAME][($i | tonumber)])' ${ALERTS_JSON_PATH})  
    echo "$ALERT_OBJECT" | jq > "$ALERTS_DEL_JSON_PATH"

    ALERT_NAME=$(jq -c --arg i "$i" --arg FOLDER_NAME "$FOLDER_NAME" '.[$FOLDER_NAME][($i | tonumber)].name' ${ALERTS_JSON_PATH})
    echo "Creating ${ALERT_NAME}...\n"
    curl -X POST \
      -H "Authorization: Bearer ${GRAFANA_TOKEN}" \
      -H "Content-type: application/json" \
      "${ADDRESS}/api/ruler/grafana/api/v1/rules/${FOLDER_NAME}" \
      -d $(jq -c '.' ${ALERTS_DEL_JSON_PATH})
  done
done