#!/bin/bash

module_name="ip_location"
main_module="" #keep it empty "" if there is no main module 
log_level="INFO" # INFO, DEBUG, ERROR
ipType="ipv4,ipv6"

########### DO NOT CHANGE ANY CODE OR TEXT AFTER THIS LINE #########

. ~/.bash_profile
 
build="${module_name}.jar"

status=`ps -ef | grep "jar" |  grep ${module_name}_module | grep $build | grep java`

echo $status

if [ "${status}" != "" ]  ## Process is currently running
then
  echo "${module_name} already started..."

else  ## No process running

  if [ "${main_module}" == "" ]
  then
     build_path="${APP_HOME}/${module_name}_module"
     log_path="${LOG_HOME}/${module_name}_module"
  else
     if [ "${main_module}" == "utility" ] || [ "${main_module}" == "api_service" ] || [ "${main_module}" == "gui" ]
     then
       build_path="${APP_HOME}/${main_module}/${module_name}"
       log_path="${LOG_HOME}/${main_module}/${module_name}"
     else
       build_path="${APP_HOME}/${main_module}_module/${module_name}"
       log_path="${LOG_HOME}/${main_module}_module/${module_name}"
     fi
  fi
  
   cd ${build_path}/script
  
   i=0
   for j in ${ipType//,/ }
    do
      array[$i]=$j;
      echo "for ${array[$i]}"
      mkdir -p $log_path/${array[$i]}/

      info_log_file=${log_path}/${array[$i]}/${module_name}_${array[$i]}_script_`date '+%Y%m%d'`.log
      error_log_file=${log_path}/${array[$i]}/${module_name}_${array[$i]}_script_`date '+%Y%m%d'`.error

      echo "Starting ${module_name}_${array[$i]} ..."
      . script.sh ${array[$i]} 1>>${info_log_file} 2>>${error_log_file} & 
     
     sleep 5
   done
 echo "Process ${module_name} is completed !!!"

fi
