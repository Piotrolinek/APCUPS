#!/bin/bash

# Get the APC status
status=$(apcaccess status)

# Extract necessary data from the apcaccess output
APC=$(echo "$status" | grep "APC" | cut -d ":" -f 2 | xargs)
DATE=$(echo "$status" | grep "DATE" | cut -d ":" -f 2 | xargs)
HOSTNAME=$(echo "$status" | grep "HOSTNAME" | cut -d ":" -f 2 | xargs)
VERSION=$(echo "$status" | grep "VERSION" | cut -d ":" -f 2 | xargs)
UPSNAME=$(echo "$status" | grep "UPSNAME" | cut -d ":" -f 2 | xargs)
CABLE=$(echo "$status" | grep "CABLE" | cut -d ":" -f 2 | xargs)
DRIVER=$(echo "$status" | grep "DRIVER" | cut -d ":" -f 2 | xargs)
UPSMODE=$(echo "$status" | grep "UPSMODE" | cut -d ":" -f 2 | xargs)
STARTTIME=$(echo "$status" | grep "STARTTIME" | cut -d ":" -f 2 | xargs)
MODEL=$(echo "$status" | grep "MODEL" | cut -d ":" -f 2 | xargs)
STATUS=$(echo "$status" | grep "STATUS" | cut -d ":" -f 2 | xargs)
BCHARGE=$(echo "$status" | grep "BCHARGE" | cut -d ":" -f 2 | xargs)
TIMELEFT=$(echo "$status" | grep "TIMELEFT" | cut -d ":" -f 2 | xargs)
MBATTCHG=$(echo "$status" | grep "MBATTCHG" | cut -d ":" -f 2 | xargs)
MINTIMEL=$(echo "$status" | grep "MINTIMEL" | cut -d ":" -f 2 | xargs)
MAXTIME=$(echo "$status" | grep "MAXTIME" | cut -d ":" -f 2 | xargs)
ALARMDEL=$(echo "$status" | grep "ALARMDEL" | cut -d ":" -f 2 | xargs)
BATTV=$(echo "$status" | grep "BATTV" | cut -d ":" -f 2 | xargs)
NUMXFERS=$(echo "$status" | grep "NUMXFERS" | cut -d ":" -f 2 | xargs)
TONBATT=$(echo "$status" | grep "TONBATT" | cut -d ":" -f 2 | xargs)
CUMONBATT=$(echo "$status" | grep "CUMONBATT" | cut -d ":" -f 2 | xargs)
XOFFBATT=$(echo "$status" | grep "XOFFBATT" | cut -d ":" -f 2 | xargs)
STATFLAG=$(echo "$status" | grep "STATFLAG" | cut -d ":" -f 2 | xargs)
MANDATE=$(echo "$status" | grep "MANDATE" | cut -d ":" -f 2 | xargs)
SERIALNO=$(echo "$status" | grep "SERIALNO" | cut -d ":" -f 2 | xargs)
NOMBATTV=$(echo "$status" | grep "NOMBATTV" | cut -d ":" -f 2 | xargs)
FIRMWARE=$(echo "$status" | grep "FIRMWARE" | cut -d ":" -f 2 | xargs)
ENDAPC=$(echo "$status" | grep "END APC" | cut -d ":" -f 2 | xargs)

# Create JSON structure
json_output=$(cat <<EOF
{
  "APC": "$APC",
  "DATE": "$DATE",
  "HOSTNAME": "$HOSTNAME",
  "VERSION": "$VERSION",
  "UPSNAME": "$UPSNAME",
  "CABLE": "$CABLE",
  "DRIVER": "$DRIVER",
  "UPSMODE": "$UPSMODE",
  "STARTTIME": "$STARTTIME",
  "MODEL": "$MODEL",
  "STATUS": "$STATUS",
  "BCHARGE": "$BCHARGE",
  "TIMELEFT": "$TIMELEFT",
  "MBATTCHG": "$MBATTCHG",
  "MINTIMEL": "$MINTIMEL",
  "MAXTIME": "$MAXTIME",
  "ALARMDEL": "$ALARMDEL",
  "BATTV": "$BATTV",
  "NUMXFERS": "$NUMXFERS",
  "TONBATT": "$TONBATT",
  "CUMONBATT": "$CUMONBATT",
  "XOFFBATT": "$XOFFBATT",
  "STATFLAG": "$STATFLAG",
  "MANDATE": "$MANDATE",
  "SERIALNO": "$SERIALNO",
  "NOMBATTV": "$NOMBATTV",
  "FIRMWARE": "$FIRMWARE",
  "ENDAPC": "$ENDAPC"
}
EOF
)

# Write the JSON output to a file
echo "$json_output" > /var/www/html/apcstatus.json
