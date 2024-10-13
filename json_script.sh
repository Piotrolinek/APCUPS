#!/bin/bash

json_output=$(apcaccess status | awk -F ': ' '
    BEGIN { print "{" }
    /APC      /{ print "\"APC\": \"" $2 "\"," }
    /DATE     /{ print "\"DATE\": \"" $2 "\"," }
    /HOSTNAME /{ print "\"HOSTNAME\": \"" $2 "\"," }
    /VERSION  /{ print "\"VERSION\": \"" $2 "\"," }
    /UPSNAME  /{ print "\"UPSNAME\": \"" $2 "\"," }
    /CABLE    /{ print "\"CABLE\": \"" $2 "\"," }
    /DRIVER   /{ print "\"DRIVER\": \"" $2 "\"," }
    /MODEL    /{ print "\"MODEL\": \"" $2 "\"," }
    /UPSMODE  /{ print "\"UPSMODE\": \"" $2 "\"," }
    /STARTTIME/{ print "\"STARTTIME\": \"" $2 "\"," }
    /STATUS   /{ print "\"STATUS\": \"" $2 "\"," }
    /MASTERUPD/{ print "\"MASTERUPD\": \"" $2 "\"," }
    /LINEV    /{ print "\"LINEV\": \"" $2 "\"," }
    /NOMINV   /{ print "\"NOMINV\": \"" $2 "\"," }
    /LOADPCT  /{ print "\"LOADPCT\": \"" $2 "\"," }
    /BCHARGE  /{ print "\"BCHARGE\": \"" $2 "\"," }
    /TIMELEFT /{ print "\"TIMELEFT\": \"" $2 "\"," }
    /MBATTCHG /{ print "\"MBATTCHG\": \"" $2 "\"," }
    /MINTIMEL /{ print "\"MINTIMEL\": \"" $2 "\"," }
    /MAXTIME  /{ print "\"MAXTIME\": \"" $2 "\"," }
    /MAXLINEV /{ print "\"MAXLINEV\": \"" $2 "\"," }
    /MINLINEV /{ print "\"MINLINEV\": \"" $2 "\"," }
    /OUTPUTV  /{ print "\"OUTPUTV\": \"" $2 "\"," }
    /SENSE    /{ print "\"SENSE\": \"" $2 "\"," }
    /DWAKE    /{ print "\"DWAKE\": \"" $2 "\"," }
    /DSHUTD   /{ print "\"DSHUTD\": \"" $2 "\"," }
    /DLOWBATT /{ print "\"DLOWBATT\": \"" $2 "\"," }
    /LOTRANS  /{ print "\"LOTRANS\": \"" $2 "\"," }
    /HITRANS  /{ print "\"HITRANS\": \"" $2 "\"," }
    /RETPCT   /{ print "\"RETPCT\": \"" $2 "\"," }
    /ITEMP    /{ print "\"ITEMP\": \"" $2 "\"," }
    /ALARMDEL /{ print "\"ALARMDEL\": \"" $2 "\"," }
    /BATTV    /{ print "\"BATTV\": \"" $2 "\"," }
    /LINEFREQ /{ print "\"LINEFREQ\": \"" $2 "\"," }
    /LASTXFER /{ print "\"LASTXFER\": \"" $2 "\"," }
    /NUMXFERS /{ print "\"NUMXFERS\": \"" $2 "\"," }
    /XONBATT  /{ print "\"XONBATT\": \"" $2 "\"," }
    /TONBATT  /{ print "\"TONBATT\": \"" $2 "\"," }
    /CUMONBATT/{ print "\"CUMONBATT\": \"" $2 "\"," }
    /XOFFBAT  /{ print "\"XOFFBAT\": \"" $2 "\"," }
    /SELFTEST /{ print "\"SELFTEST\": \"" $2 "\"," }
    /STESTI   /{ print "\"STESTI\": \"" $2 "\"," }
    /STATFLAG /{ print "\"STATFLAG\": \"" $2 "\"," }
    /DIPSW    /{ print "\"DIPSW\": \"" $2 "\"," }
    /REG1     /{ print "\"REG1\": \"" $2 "\"," }
    /REG2     /{ print "\"REG2\": \"" $2 "\"," }
    /REG3     /{ print "\"REG3\": \"" $2 "\"," }
    /MANDATE  /{ print "\"MANDATE\": \"" $2 "\"," }
    /SERIALNO /{ print "\"SERIALNO\": \"" $2 "\"," }
    /BATTDATE /{ print "\"BATTDATE\": \"" $2 "\"," }
    /NOMOUTV  /{ print "\"NOMOUTV\": \"" $2 "\"," }
    /NOMBATTV /{ print "\"NOMBATTV\": \"" $2 "\"," }
    /EXTBATTS /{ print "\"EXTBATTS\": \"" $2 "\"," }
    /BADBATTS /{ print "\"BADBATTS\": \"" $2 "\"," }
    /FIRMWARE /{ print "\"FIRMWARE\": \"" $2 "\"," }
    /APCMODEL /{ print "\"APCMODEL\": \"" $2 "\"," }
    /LINEV    /{ print "\"LINEV\": \"" $2 "\"," }
    /LOADPCT  /{ print "\"LOADPCT\": \"" $2 "\"," }
    /MBATTCHG /{ print "\"MBATTCHG\": \"" $2 "\"," }
    /MINTIMEL /{ print "\"MINTIMEL\": \"" $2 "\"," }
    /MAXTIME  /{ print "\"MAXTIME\": \"" $2 "\"," }
    /MAXLINEV /{ print "\"MAXLINEV\": \"" $2 "\"," }
    /MINLINEV /{ print "\"MINLINEV\": \"" $2 "\"," }
    /OUTPUTV  /{ print "\"OUTPUTV\": \"" $2 "\"," }
    /BATTV    /{ print "\"BATTV\": \"" $2 "\"," }
    /STATFLAG /{ print "\"STATFLAG\": \"" $2 "\"," }
    /LINEV    /{ print "\"LINEV\": \"" $2 "\"," }
    /LOADPCT  /{ print "\"LOADPCT\": \"" $2 "\"," }
    /BCHARGE  /{ print "\"BCHARGE\": \"" $2 "\"," }
    /TIMELEFT /{ print "\"TIMELEFT\": \"" $2 "\"," }
    /MBATTCHG /{ print "\"MBATTCHG\": \"" $2 "\"," }
    /MINTIMEL /{ print "\"MINTIMEL\": \"" $2 "\"," }
    /MAXTIME  /{ print "\"MAXTIME\": \"" $2 "\"," }
    /OUTPUTV  /{ print "\"OUTPUTV\": \"" $2 "\"," }
    /DWAKE    /{ print "\"DWAKE\": \"" $2 "\"," }
    /DSHUTD   /{ print "\"DSHUTD\": \"" $2 "\"," }
    /LOTRANS  /{ print "\"LOTRANS\": \"" $2 "\"," }
    /HITRANS  /{ print "\"HITRANS\": \"" $2 "\"," }
    /RETPCT   /{ print "\"RETPCT\": \"" $2 "\"," }
    /ITEMP    /{ print "\"ITEMP\": \"" $2 "\"," }
    /ALARMDEL /{ print "\"ALARMDEL\": \"" $2 "\"," }
    /BATTV    /{ print "\"BATTV\": \"" $2 "\"," }
    /LINEFREQ /{ print "\"LINEFREQ\": \"" $2 "\"," }
    /LASTXFER /{ print "\"LASTXFER\": \"" $2 "\"," }
    /NUMXFERS /{ print "\"NUMXFERS\": \"" $2 "\"," }
    /XONBATT  /{ print "\"XONBATT\": \"" $2 "\"," }
    /TONBATT  /{ print "\"TONBATT\": \"" $2 "\"," }
    /CUMONBATT/{ print "\"CUMONBATT\": \"" $2 "\"," }
    /XOFFBAT  /{ print "\"XOFFBAT\": \"" $2 "\"," }
    /SELFTEST /{ print "\"SELFTEST\": \"" $2 "\"," }
    /STATFLAG /{ print "\"STATFLAG\": \"" $2 "\"," }
    /MANDATE  /{ print "\"MANDATE\": \"" $2 "\"," }
    /SERIALNO /{ print "\"SERIALNO\": \"" $2 "\"," }
    /BATTDATE /{ print "\"BATTDATE\": \"" $2 "\"," }
    /NOMBATTV /{ print "\"NOMBATTV\": \"" $2 "\"," }
    /FIRMWARE /{ print "\"FIRMWARE\": \"" $2 "\"," }
    /APCMODEL /{ print "\"APCMODEL\": \"" $2 "\"," }
    /LINEV    /{ print "\"LINEV\": \"" $2 "\"," }
    /LOADPCT  /{ print "\"LOADPCT\": \"" $2 "\"," }
    /BCHARGE  /{ print "\"BCHARGE\": \"" $2 "\"," }
    /TIMELEFT /{ print "\"TIMELEFT\": \"" $2 "\"," }
    /MBATTCHG /{ print "\"MBATTCHG\": \"" $2 "\"," }
    /MINTIMEL /{ print "\"MINTIMEL\": \"" $2 "\"," }
    /MAXTIME  /{ print "\"MAXTIME\": \"" $2 "\"," }
    /MAXLINEV /{ print "\"MAXLINEV\": \"" $2 "\"," }
    /MINLINEV /{ print "\"MINLINEV\": \"" $2 "\"," }
    /OUTPUTV  /{ print "\"OUTPUTV\": \"" $2 "\"," }
    /SENSE    /{ print "\"SENSE\": \"" $2 "\"," }
    /DWAKE    /{ print "\"DWAKE\": \"" $2 "\"," }
    /DSHUTD   /{ print "\"DSHUTD\": \"" $2 "\"," }
    /DLOWBATT /{ print "\"DLOWBATT\": \"" $2 "\"," }
    /LOTRANS  /{ print "\"LOTRANS\": \"" $2 "\"," }
    /HITRANS  /{ print "\"HITRANS\": \"" $2 "\"," }
    /RETPCT   /{ print "\"RETPCT\": \"" $2 "\"," }
    /ITEMP    /{ print "\"ITEMP\": \"" $2 "\"," }
    /ALARMDEL /{ print "\"ALARMDEL\": \"" $2 "\"," }
    /LINEFREQ /{ print "\"LINEFREQ\": \"" $2 "\"," }
    /NUMXFERS /{ print "\"NUMXFERS\": \"" $2 "\"," }
    /TONBATT  /{ print "\"TONBATT\": \"" $2 "\"," }
    /CUMONBATT/{ print "\"CUMONBATT\": \"" $2 "\"," }
    /XOFFBATT /{ print "\"XOFFBATT\": \"" $2 "\"," }
    /STESTI   /{ print "\"STESTI\": \"" $2 "\"," }
    /STATFLAG /{ print "\"STATFLAG\": \"" $2 "\"," }
    /DIPSW    /{ print "\"DIPSW\": \"" $2 "\"," }
    /MANDATE  /{ print "\"MANDATE\": \"" $2 "\"," }
    /SERIALNO /{ print "\"SERIALNO\": \"" $2 "\"," }
    /BATTDATE /{ print "\"BATTDATE\": \"" $2 "\"," }
    /NOMOUTV  /{ print "\"NOMOUTV\": \"" $2 "\"," }
    /NOMPOWER /{ print "\"NOMPOWER\": \"" $2 "\"," }
    /EXTBATTS /{ print "\"EXTBATTS\": \"" $2 "\"," }
    /BADBATTS /{ print "\"BADBATTS\": \"" $2 "\"," }
    /FIRMWARE /{ print "\"FIRMWARE\": \"" $2 "\"," }
    /APCMODEL /{ print "\"APCMODEL\": \"" $2 "\"," }
    /MBATTCHG /{ print "\"MBATTCHG\": \"" $2 "\"," }
    /MINTIMEL /{ print "\"MINTIMEL\": \"" $2 "\"," }
    /MAXTIME  /{ print "\"MAXTIME\": \"" $2 "\"," }
    /NUMXFERS /{ print "\"NUMXFERS\": \"" $2 "\"," }
    /TONBATT  /{ print "\"TONBATT\": \"" $2 "\"," }
    /CUMONBATT/{ print "\"CUMONBATT\": \"" $2 "\"," }
    /XOFFBATT /{ print "\"XOFFBATT\": \"" $2 "\"," }
    /STATFLAG /{ print "\"STATFLAG\": \"" $2 "\"," }
    /HUMIDITY /{ print "\"HUMIDITY\": \"" $2 "\"," }
    /AMBTEMP  /{ print "\"AMBTEMP\": \"" $2 "\"," }
    /LINEFAIL /{ print "\"LINEFAIL\": \"" $2 "\"," }
    /BATTSTAT /{ print "\"BATTSTAT\": \"" $2 "\"," }
    /LASTXFER /{ print "\"LASTXFER\": \"" $2 "\"," }
    /LINEFAIL /{ print "\"LINEFAIL\": \"" $2 "\"," }
    /BATTSTAT /{ print "\"BATTSTAT\": \"" $2 "\"," }
    /STATFLAG /{ print "\"STATFLAG\": \"" $2 "\"," }
    /END APC  /{ print "\"END APC\": \"" $2 "\"" }
    END { print "}" }
')

json_output_clean=$(echo "$json_output" | awk '!seen[$0]++')

echo "$json_output_clean" > /var/www/html/apcstatus.json