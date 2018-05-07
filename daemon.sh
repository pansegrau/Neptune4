#!/bin/bash

if [ -z "$METERID" ]; then
  echo "METERID not set, launching in debug mode"
  echo "If you don't know your Meter's ID, you'll need to figure it out manually"
  echo "Easiest way is to go outside and read your meter, then match it to a meter id in the logs"
  echo "Note: It may take a several minutes to read all the nearby meters"

  rtl_tcp &> /dev/null &
  sleep 10 #Let rtl_tcp startup and open a port

  rtlamr -msgtype=r900
  exit 0
fi

UNIT_DIVISOR=1000
UNIT="Cubic Meters"

# Kill this script (and restart the container) if we haven't seen an update in 30 minutes
# Nasty issue probably related to a memory leak, but this works really well, so not changing it
./watchdog.sh 30 updated.log &

while true; do
  # Suppress the very verbose output of rtl_tcp and background the process
  rtl_tcp &> /dev/null &
  rtl_tcp_pid=$! # Save the pid for murder later
  sleep 10 #Let rtl_tcp startup and open a port

  json=$(rtlamr -msgtype=r900 -filterid=$METERID -single=true -format=json)
  echo "Meter info: $json"

  consumption=$(echo $json | python -c "import json,sys;obj=json.load(sys.stdin);print float(obj[\"Message\"][\"Consumption\"])/$UNIT_DIVISOR")
  echo "Total Consumption: $consumption $UNIT"

#Collect data from Irrigation meter

consumption=$(echo $json | python -c 'import json,sys;obj=json.load(sys.stdin);print float(obj["Message"]["Consumption"])/1000')
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "Consumption Irrigation Meter: $consumption Cubic Meters"
  irrmeter=$consumption
  irr=$(echo $json | python -c 'import json,sys;obj=json.load(sys.stdin);print float(obj["Message"]["Consumption"])/1')
  
  #Now process that data from Irrigation meter
  #convert to integer
  irrint=${irr%.*}
  
  # record data for nightly consumption of Irrigation meter at 1 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 19 && `date +%H` -lt 20 ]];then
    echo "Presently processing 12 PM noon to 1 PM"
    t1PM=$irrint
    echo $t1PM > /data/bin1PM
  fi
  # record data for nightly consumption of Irrigation meter at 2 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 20 && `date +%H` -lt 21 ]];then
    echo "Presently processing 1 PM to 2 PM"
    t2PM=$irrint
    echo $t2PM > /data/bin2PM
  fi
  # record data for nightly consumption of Irrigation meter at 3 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 21 && `date +%H` -lt 22 ]];then
    echo "Presently processing 2 PM to 3 PM"
    t3PM=$irrint
    echo $t3PM > /data/bin3PM
  fi
  # record data for nightly consumption of Irrigation meter at 4 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 22 && `date +%H` -lt 23 ]];then
    echo "Presently processing 3 PM to 4 PM"
    t4PM=$irrint
    echo $t4PM > /data/bin4PM
  fi
  # record data for nightly consumption of Irrigation meter at 5 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 23 && `date +%H` -lt 24 ]];then
    echo "Presently processing 4 PM to 5 PM"
    t5PM=$irrint
    echo $t5PM > /data/bin5PM
  fi
  # record data for nightly consumption of Irrigation meter at 6 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 0 && `date +%H` -lt 1 ]];then
    echo "Presently processing 5 to 6 PM"
    t6PM=$irrint
    echo $t6PM > /data/bin6PM
  fi
  # record data for nightly consumption of Irrigation meter at 7 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 1 && `date +%H` -lt 2 ]];then
    echo "Presently processing 6 PM to 7 PM"
    t7PM=$irrint
    echo $t7PM > /data/bin7PM
  fi
  # record data for nightly consumption of Irrigation meter at 8 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 2 && `date +%H` -lt 3 ]];then
    echo "Presently processing 7 PM to 8 PM"
    t8PM=$irrint
    echo $t8PM > /data/bin8PM
  fi
  # record data for nightly consumption of Irrigation meter at 9 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 3 && `date +%H` -lt 4 ]];then
    echo "Presently processing 8 PM to 9 PM"
    t9PM=$irrint
    echo $t9PM > /data/bin9PM
  fi
  # record data for nightly consumption of Irrigation meter at 10 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 4 && `date +%H` -lt 5 ]];then
    echo "Presently processing 9 PM to 10 PM"
    t10PM=$irrint
    echo $t10PM > /data/bin10PM
  fi
  # record data for nightly consumption of Irrigation meter at 11 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 5 && `date +%H` -lt 6 ]];then
    echo "Presently processing 10 to 11 PM"
    t11PM=$irrint
    echo $t11PM > /data/bin11PM
  fi
  # record data for nightly consumption of Irrigation meter at 12 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 6 && `date +%H` -lt 7 ]];then
    echo "Presently processing 11 PM to 12 AM midnight"
    t12AM=$irrint
    echo $t12AM > /data/bin12AM
  fi
  # record data for nightly consumption of Irrigation meter at 1 AM (time is adjusted due to UTC)
  if [[ `date +%-H` -ge 7 && `date +%-H` -lt 8 ]];then
    echo "Presently processing 12 AM midnight to 1 AM"
    t1AM=$irrint
    echo $t1AM > /data/bin1AM
  fi
  # record data for nightly consumption of Irrigation meter at 2 AM (time is adjusted due to UTC)
  if [[ `date +%-H` -ge 8 && `date +%-H` -lt 9 ]];then
    echo "Presently processing 1 AM to 2 AM"
    t2AM=$irrint
    echo $t2AM > /data/bin2AM
  fi
  # record data for nightly consumption of Irrigation meter at 3 AM (time is adjusted due to UTC)
  if [[ `date +%-H` -ge 9 && `date +%-H` -lt 10 ]];then
    echo "Presently processing 2 AM to 3 AM"
    t3AM=$irrint
    echo $t3AM > /data/bin3AM
  fi
  # record data for nightly consumption of Irrigation meter at 4 AM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 10 && `date +%H` -lt 11 ]];then
    echo "Presently processing 3 AM to 4 AM"
    t4AM=$irrint
    echo $t4AM > /data/bin4AM
  fi
  # record data for nightly consumption of Irrigation meter at 5 AM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 11 && `date +%H` -lt 12 ]];then
    echo "Presently processing 4 AM to 5 AM"
    t5AM=$irrint
    echo $t5AM > /data/bin5AM
  fi
  # record data for nightly consumption of Irrigation meter at 6 AM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 12 && `date +%H` -lt 13 ]];then
    echo "Presently processing 5 AM to 6 AM"
    t6AM=$irrint
    echo $t6AM > /data/bin6AM
  fi
  # record data for nightly consumption of Irrigation meter at 7 AM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 13 && `date +%H` -lt 14 ]];then
    echo "Presently processing 6 AM to 7 AM"
    t7AM=$irrint
    echo $t7AM > /data/bin7AM
  fi
  # record data for nightly consumption of Irrigation meter at 8 AM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 14 && `date +%H` -lt 15 ]];then
    echo "Presently processing 7 AM to 8 AM"
    t8AM=$irrint
    echo $t8AM > /data/bin8AM
  fi
  # record data for nightly consumption of Irrigation meter at 9 AM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 15 && `date +%H` -lt 16 ]];then
    echo "Presently processing 8 AM to 9 AM"
    t9AM=$irrint
    echo $t9AM > /data/bin9AM
  fi
  # record data for nightly consumption of Irrigation meter at 10 AM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 16 && `date +%H` -lt 17 ]];then
    echo "Presently processing 9 AM to 10 AM"
    t10AM=$irrint
    echo $t10AM > /data/bin10AM
  fi
  # record data for nightly consumption of Irrigation meter at 11 AM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 17 && `date +%H` -lt 18 ]];then
    echo "Presently processing 10 AM to 11 AM"
    t11AM=$irrint
    echo $t11AM > /data/bin11AM
  fi
  # record data for nightly consumption of Irrigation meter at 12 PM (time is adjusted due to UTC)
  if [[ `date +%H` -ge 18 && `date +%H` -lt 19 ]];then
    echo "Presently processing 11 AM to 12 PM noon"
    t12PM=$irrint
    echo $t12PM > /data/bin12PM
  fi
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

  # Replace with your custom logging code
  if [ ! -z "$CURL_API" ]; then
    echo "Logging to custom API"
    # For example, CURL_API would be "https://mylogger.herokuapp.com?value="
    # Currently uses a GET request
    curl -L "$CURL_API$consumption"
  fi

  kill $rtl_tcp_pid # rtl_tcp has a memory leak and hangs after frequent use, restarts required - https://github.com/bemasher/rtlamr/issues/49
  sleep 60 # I don't need THAT many updates

  # Let the watchdog know we've done another cycle
  touch updated.log
done

