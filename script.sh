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

# Create the updated HTML content
html_content=$(cat <<EOF
<html>
<body>
<style>
body {
    margin: 0;
    padding: 0;
    border: 0;
}
table {
    font-family:consolas;
    width: 10%;
    height: 100%;
    margin-left: auto;
    margin-right: auto;
}
th,td {
    border: 1px solid #000000;
    text-align: left;
    padding: 4px;
    width: 50%;
}
tr:nth-child(even){
    background-color: #dddddd;
}
</style>
<table>
    <tr><th>APC</th><td>${APC}</td></tr>
    <tr><th>DATE</th><td>${DATE}</td></tr>
    <tr><th>HOSTNAME</th><td>${HOSTNAME}</td></tr>
    <tr><th>VERSION</th><td>${VERSION}</td></tr>
    <tr><th>UPSNAME</th><td>${UPSNAME}</td></tr>
    <tr><th>CABLE</th><td>${CABLE}</td></tr>
    <tr><th>DRIVER</th><td>${DRIVER}</td></tr>
    <tr><th>UPSMODE</th><td>${UPSMODE}</td></tr>
    <tr><th>STARTTIME</th><td>${STARTTIME}</td></tr>
    <tr><th>MODEL</th><td>${MODEL}</td></tr>
    <tr><th>STATUS</th><td>${STATUS}</td></tr>
    <tr><th>BCHARGE</th><td>${BCHARGE}</td></tr>
    <tr><th>TIMELEFT</th><td>${TIMELEFT}</td></tr>
    <tr><th>MBATTCHG</th><td>${MBATTCHG}</td></tr>
    <tr><th>MINTIMEL</th><td>${MINTIMEL}</td></tr>
    <tr><th>MAXTIME</th><td>${MAXTIME}</td></tr>
    <tr><th>ALARMDEL</th><td>${ALARMDEL}</td></tr>
    <tr><th>BATTV</th><td>${BATTV}</td></tr>
    <tr><th>NUMXFERS</th><td>${NUMXFERS}</td></tr>
    <tr><th>TONBATT</th><td>${TONBATT}</td></tr>
    <tr><th>CUMONBATT</th><td>${CUMONBATT}</td></tr>
    <tr><th>XOFFBATT</th><td>${XOFFBATT}</td></tr>
    <tr><th>STATFLAG</th><td>${STATFLAG}</td></tr>
    <tr><th>MANDATE</th><td>${MANDATE}</td></tr>
    <tr><th>SERIALNO</th><td>${SERIALNO}</td></tr>
    <tr><th>NOMBATTV</th><td>${NOMBATTV}</td></tr>
    <tr><th>FIRMWARE</th><td>${FIRMWARE}</td></tr>
    <tr><th>END APC</th><td>${ENDAPC}</td></tr>
</table>
</body>
</html>
EOF
)

# Write the updated HTML content to the file
echo "$html_content" > /var/www/html/myhtml.html