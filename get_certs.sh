#!/bin/bash
principals=(`getcert list | grep principal | awk -F ":" '{print $2}' | tr -d " "`)
status=(`getcert list | grep status | awk -F ":" '{print $2}' | tr -d " "`)
certificates=(`getcert list | grep "certificate:" | awk -F ":" '{print $2}' | awk -F "=" '{print $3}' | tr -d "'"`)
subjects=(`getcert list | grep subject | awk -F ":" '{print $2}' | tr -d " "`)
declare -a serial_numbers
count=0
for cert in "${certificates[@]}"
do 
  serial_numbers[${count}]=$(openssl x509 -in ${cert} -noout -text | grep -i "Serial Number" | awk -F ":" '{print $2}' | awk -F " " '{print $1}')
  count=$[count+1]
done
for ((i=0;i<${#subjects[@]};i++))
do
  echo "${subjects[$i]} | ${principals[$i]} | ${serial_numbers[$i]}"
done
