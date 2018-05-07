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
#need timely updates for irrigation troubleshooting
  echo "Hourly updates for Irrigation trouble-shooting"
  t1PM=$(cat /data/bin1PM)
  t2PM=$(cat /data/bin2PM)
  t3PM=$(cat /data/bin3PM)
  t4PM=$(cat /data/bin4PM)
  t5PM=$(cat /data/bin5PM)
  t6PM=$(cat /data/bin6PM)
  t7PM=$(cat /data/bin7PM)
  t8PM=$(cat /data/bin8PM)
  t9PM=$(cat /data/bin9PM)
  t10PM=$(cat /data/bin10PM)
  t11PM=$(cat /data/bin11PM)
  t12AM=$(cat /data/bin12AM)
  t1AM=$(cat /data/bin1AM)
  t2AM=$(cat /data/bin2AM)
  t3AM=$(cat /data/bin3AM)
  t4AM=$(cat /data/bin4AM)
  t5AM=$(cat /data/bin5AM)
  t6AM=$(cat /data/bin6AM)
  t7AM=$(cat /data/bin7AM)
  t8AM=$(cat /data/bin8AM)
  t9AM=$(cat /data/bin9AM)
  t10AM=$(cat /data/bin10AM)
  t11AM=$(cat /data/bin11AM)
  t12PM=$(cat /data/bin12PM)
  q1AM=$(echo $((t1AM - t12AM)))
  q2AM=$(echo $((t2AM - t1AM)))
  q3AM=$(echo $((t3AM - t2AM)))
  q4AM=$(echo $((t4AM - t3AM)))
  q5AM=$(echo $((t5AM - t4AM)))
  q6AM=$(echo $((t6AM - t5AM)))
  q7AM=$(echo $((t7AM - t6AM)))
  q8AM=$(echo $((t8AM - t7AM)))
  q9AM=$(echo $((t9AM - t8AM)))
  q10AM=$(echo $((t10AM - t9AM)))
  q11AM=$(echo $((t11AM - t10AM)))
  q12PM=$(echo $((t12PM - t11AM)))
  q1PM=$(echo $((t1PM - t12PM)))
  q2PM=$(echo $((t2PM - t1PM)))
  q3PM=$(echo $((t3PM - t2PM)))
  q4PM=$(echo $((t4PM - t3PM)))
  q5PM=$(echo $((t5PM - t4PM)))
  q6PM=$(echo $((t6PM - t5PM)))
  q7PM=$(echo $((t7PM - t6PM)))
  q8PM=$(echo $((t8PM - t7PM)))
  q9PM=$(echo $((t9PM - t8PM)))
  q10PM=$(echo $((t10PM - t9PM)))
  q11PM=$(echo $((t11PM - t10PM)))
  q12AM=$(echo $((t12AM - t11PM)))
  
  f1AM=$(echo $((100 * q1AM / 60))| sed 's/..$/.&/')
  f2AM=$(echo $((100 * q2AM / 60))| sed 's/..$/.&/')
  f3AM=$(echo $((100 * q3AM / 60))| sed 's/..$/.&/')
  f4AM=$(echo $((100 * q4AM / 60))| sed 's/..$/.&/')
  f5AM=$(echo $((100 * q5AM / 60))| sed 's/..$/.&/')
  f6AM=$(echo $((100 * q6AM / 60))| sed 's/..$/.&/')
  f7AM=$(echo $((100 * q7AM / 60))| sed 's/..$/.&/')
  f8AM=$(echo $((100 * q8AM / 60))| sed 's/..$/.&/')
  f9AM=$(echo $((100 * q9AM / 60))| sed 's/..$/.&/')
  f10AM=$(echo $((100 * q10AM / 60))| sed 's/..$/.&/')
  f11AM=$(echo $((100 * q11AM / 60))| sed 's/..$/.&/')
  f12PM=$(echo $((100 * q12PM / 60))| sed 's/..$/.&/')
  f1PM=$(echo $((100 * q1PM / 60))| sed 's/..$/.&/')
  f2PM=$(echo $((100 * q2PM / 60))| sed 's/..$/.&/')
  f3PM=$(echo $((100 * q3PM / 60))| sed 's/..$/.&/')
  f4PM=$(echo $((100 * q4PM / 60))| sed 's/..$/.&/')
  f5PM=$(echo $((100 * q5PM / 60))| sed 's/..$/.&/')
  f6PM=$(echo $((100 * q6PM / 60))| sed 's/..$/.&/')
  f7PM=$(echo $((100 * q7PM / 60))| sed 's/..$/.&/')
  f8PM=$(echo $((100 * q8PM / 60))| sed 's/..$/.&/')
  f9PM=$(echo $((100 * q9PM / 60))| sed 's/..$/.&/')
  f10PM=$(echo $((100 * q10PM / 60))| sed 's/..$/.&/')
  f11PM=$(echo $((100 * q11PM / 60))| sed 's/..$/.&/')
  f12AM=$(echo $((100 * q12AM / 60))| sed 's/..$/.&/')
  
  echo "Quantity and the Approximate Average Flow-Rate each hour"
  echo "___________________________________________________________________________________________"
  echo "1 AM  $q1AM     litres,     $f1AM litres per min"    
  echo "2 AM  $q2AM     litres,     $f2AM litres per min" 
  echo "3 AM  $q3AM     litres,     $f3AM litres per min" 
  echo "4 AM  $q4AM     litres,     $f4AM litres per min" 
  echo "5 AM  $q5AM     litres,     $f5AM litres per min" 
  echo "6 AM  $q6AM     litres,     $f6AM litres per min" 
  echo "7 AM  $q7AM     litres,     $f7AM litres per min" 
  echo "8 AM  $q8AM     litres,     $f8AM litres per min" 
  echo "9 AM  $q9AM     litres,     $f9AM litres per min" 
  echo "10 AM $q10AM     litres,     $f10AM litres per min" 
  echo "11 AM $q11AM     litres,     $f11AM litres per min"
  echo "12 PM $q12PM     litres,     $f12PM litres per min"
  echo "1 PM  $q1PM     litres,     $f1PM litres per min"
  echo "2 PM  $q2PM     litres,     $f2PM litres per min"
  echo "3 PM  $q3PM     litres,     $f3PM litres per min"
  echo "4 PM  $q4PM     litres,     $f4PM litres per min"
  echo "5 PM  $q5PM     litres,     $f5PM litres per min"
  echo "6 PM  $q6PM     litres,     $f6PM litres per min"
  echo "7 PM  $q7PM     litres,     $f7PM litres per min"
  echo "8 PM  $q8PM     litres,     $f8PM litres per min"
  echo "9 PM  $q9PM     litres,     $f9PM litres per min"
  echo "10 PM $q10PM     litres,     $f10PM litres per min"
  echo "11 PM $q11PM     litres,     $f11PM litres per min"
  echo "12 AM $q12AM     litres,     $f12AM litres per min"

 echo "********************************************************************************************"
  echo "*                Total Consumption Data in Cubic Meters                                    "
  echo "*    Consumption Meter One                           $irrmeter Cubic Meters                "
  echo "*    Consumption Meter Two                           $irrmeter Cubic Meters                "
  echo "*    Consumption Meter Three                         $irrmeter Cubic Meters              "
echo "********************************************************************************************"

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

