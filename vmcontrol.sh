#!/bin/bash
#===============================================================================
#
#         FILE: vmcontrol.sh
#
#        USAGE: ./vmcontrol.sh {start|stop|list}
#
#  DESCRIPTION: script to control vbox virtual hosts
# RETURUN CODE: 255: must be run as user root
#               254: parameter not provided
#               253: parameter not listed
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Kevin CS Zhang (kcsz)
#        EMAIL: cs.zhang@continental-corporation.com
# ORGANIZATION: Continental
#      VERSION: 1.0
#      CREATED: 03/17/2013 v1.0
#      UPDATED:
#===============================================================================

# Treat unset variables as an error
set -o nounset

# Version info
version="1.0";

# script must be run as user root
if [ `id -nu` != "root" ];then
  echo "Please run this script as user root.";
  exit 255;
fi

#---   ----------------------------------------------------------------
#          NAME:  vm_list
#   DESCRIPTION:  check vms status
#    PARAMETERS:  vms name
#       RETURNS:  status
#-------------------------------------------------------------------------------
vm_list ()
{
  #n=1
  vboxmanage list runningvms>$vms
  for i in `vboxmanage list vms|awk -F'"' '{print $2}'`;do
    #echo -en "[$n] $i: "
    echo -en "$i:"
    count=`grep $i $vms|wc -l`
    #count=`vboxmanage list runningvms|grep $i|wc -l`
    if [[ $count -eq 1 ]];then
      status="running"
    else
      status="stop"
    fi
    echo $status
  #  n=`expr $n + 1`
  done
}       # ----------  end of vm_list  ----------

#---   ----------------------------------------------------------------
#          NAME:  USAGE
#   DESCRIPTION:  echo USAGE
#    PARAMETERS:
#       RETURNS:
#-------------------------------------------------------------------------------
USAGE ()
{
  echo "Usage: $0 {start|stop|list}"
}       # ----------  end of USAGE  ----------

# script must be provided parameter
if [[ $# -ne 1 ]];then
  USAGE
  exit 254
fi

#-------------------------------------------------------------------------------
# user defined parameters
#-------------------------------------------------------------------------------
cmd=$1
vms="/tmp/vms.log"


case "$cmd" in
start)
        menu=`vm_list`
        OLD_IFS=$IFS
        IFS=$(echo -ne "\n\r")
        PS3="Please select vm: "
        select opt in $menu
        do
          vm=`echo $opt|awk -F':' '{print $1}'`
          status=`echo $opt|awk -F':' '{print $2}'`
          echo "your select is: $vm"
          if [[ "$status" != "running" ]];then
            vboxmanage startvm $vm --type headless
            #echo "start"
          else
            echo "$vm is already running."
          fi
          [ -n "$vm" ] && break
        done
        IFS=$OLD_IFS
;;
stop)
        menu=`vm_list`
        OLD_IFS=$IFS
        IFS=$(echo -ne "\n\r")
        PS3="Please select vm: "
        select opt in $menu
        do
          vm=`echo $opt|awk -F':' '{print $1}'`
          status=`echo $opt|awk -F':' '{print $2}'`
          echo "your select is: $vm"
          if [[ "$status" != "stop" ]];then
            vboxmanage controlvm $vm poweroff
            #echo "stop"
          else
            echo "$vm is already stop."
          fi
          [ -n "$vm" ] && break
        done
        IFS=$OLD_IFS
;;
list)
        vm_list
;;
*)
        USAGE
        exit 253
;;
esac
