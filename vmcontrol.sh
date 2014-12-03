#!/bin/bash
#===============================================================================
#
#         FILE: vmcontrol.sh
#
#        USAGE: ./vmcontrol.sh {startvm|stopvm|listvm|takess|deletess|listss|resotress|renamess}
#
#  DESCRIPTION: script to control vbox virtual hosts
# RETURUN CODE: 255: must be run as user root
#               254: parameter not provided
#               253: parameter not listed
#               252: platform not supported
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Kevin CS Zhang (kcsz)
#        EMAIL: cs.zhang@continental-corporation.com
# ORGANIZATION: Continental AG
#      VERSION: 1.4
#      CREATED: 03/17/2013 v1.0
#      UPDATED: 08/13/2014 v1.1 snapshot create,delete,list added
#               08/23/2014 v1.2 snapshot rename added
#               11/25/2014 v1.3 sort vm_list output; repace awk with gawk
#               12/01/2014 v1.4 windows platform support added which requires cygwin
#===============================================================================

# Treat unset variables as an error
set -o nounset

# Version info
version="1.4";

#PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
PLATFORM=`uname`

case $PLATFORM in
  Linux)
      if [ `id -nu` != "root" ];then
        echo "Please run this script as user root.";
        exit 255;
      else
        VBOXMAN="vboxmanage"
      fi
  ;;
  CYGWIN_NT-6.1)
      VBOXMAN="VBoxManage.exe"
  ;;
  *)
      echo "Platform is NOT supported"
      exit 252
  ;;
esac

#---   ----------------------------------------------------------------
#          NAME:  vm_list
#   DESCRIPTION:  check vms status 
#    PARAMETERS:  vms name
#       RETURNS:  status
#-------------------------------------------------------------------------------
vm_list () 
{
  #n=1
  $VBOXMAN list runningvms|sort>$vms
  for i in `$VBOXMAN list vms|sort|gawk -F'"' '{print $2}'`;do
    #echo -en "[$n] $i: "
    echo -en "$i:"
    count=`grep $i $vms|wc -l`
    #count=`$VBOXMAN list runningvms|grep $i|wc -l`
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
  echo "Usage: $0 {startvm|stopvm|listvm|takess|deletess|listss|resotress|renamess}"
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
vms="vms.log"

#main

case "$cmd" in
startvm)
        menu=`vm_list`
        OLD_IFS=$IFS
        IFS=$(echo -ne "\n\r")
        PS3="Please select vm: "
        select opt in $menu
        do
          vm=`echo $opt|gawk -F':' '{print $1}'`
          status=`echo $opt|gawk -F':' '{print $2}'`
          echo "your select is: $vm"
          if [[ "$status" != "running" ]];then
            $VBOXMAN startvm $vm --type headless
            #echo "start"
          else
            echo "$vm is already running."
          fi
          [ -n "$vm" ] && break
        done
        IFS=$OLD_IFS
;;
stopvm)
        menu=`vm_list`
        OLD_IFS=$IFS
        IFS=$(echo -ne "\n\r")
        PS3="Please select vm: "
        select opt in $menu
        do
          vm=`echo $opt|gawk -F':' '{print $1}'`
          status=`echo $opt|gawk -F':' '{print $2}'`
          echo "your select is: $vm"
          if [[ "$status" != "stop" ]];then
            $VBOXMAN controlvm $vm poweroff
            #echo "stop"
          else
            echo "$vm is already stop."
          fi
          [ -n "$vm" ] && break
        done
        IFS=$OLD_IFS
;;
listvm)
        vm_list
;;
takess)
        vm_menu=`vm_list`
        OLD_IFS=$IFS
        IFS=$(echo -ne "\n\r")
        PS3="Please select vm: "
        select opt in $vm_menu
        do
          vm=`echo $opt|gawk -F':' '{print $1}'`
          echo "your select is: $vm"
          echo -n "Please specify snapshot name to take: "
	  read ss_name
          $VBOXMAN snapshot $vm take ${ss_name}
          [ -n "$vm" ] && break
        done
        IFS=$OLD_IFS
;;
deletess)
        vm_menu=`vm_list`
        OLD_IFS=$IFS
        IFS=$(echo -ne "\n\r")
        PS3="Please select vm: "
        select opt in $vm_menu
        do
          vm=`echo $opt|gawk -F':' '{print $1}'`
          echo "your select is: $vm"
          ss_menu=`$VBOXMAN snapshot $vm list|grep Name|gawk -F'(' '{print $1}'`
          PS3="Please select snapshot name to delete: "
          select opt in $ss_menu
          do
            ss_name=`echo $opt|gawk -F':' '{print $2}'|sed -e 's/ //g'`
            $VBOXMAN snapshot $vm delete ${ss_name}
            [ -n "$ss_name" ] && break
          done
          [ -n "$vm" ] && break
        done
        IFS=$OLD_IFS
;;
restoress)
	vm_menu=`vm_list`
        OLD_IFS=$IFS
        IFS=$(echo -ne "\n\r")
        PS3="Please select vm: "
        select opt in $vm_menu
        do
          vm=`echo $opt|gawk -F':' '{print $1}'`
          echo "your select is: $vm"
	  ss_menu=`$VBOXMAN snapshot $vm list|grep Name|gawk -F'(' '{print $1}'`
	  PS3="Please select snapshot name to restore: "
          select opt in $ss_menu
	  do 
	    ss_name=`echo $opt|gawk -F':' '{print $2}'|sed -e 's/ //g'`
	    $VBOXMAN snapshot $vm restore ${ss_name} 
            [ -n "$ss_name" ] && break
          done
	  [ -n "$vm" ] && break
        done
        IFS=$OLD_IFS
;;
renamess)
        vm_menu=`vm_list`
        OLD_IFS=$IFS
        IFS=$(echo -ne "\n\r")
        PS3="Please select vm: "
        select opt in $vm_menu
        do
          vm=`echo $opt|gawk -F':' '{print $1}'`
          echo "your select is: $vm"
          ss_menu=`$VBOXMAN snapshot $vm list|grep Name|gawk -F'(' '{print $1}'`
          PS3="Please select snapshot name to rename: "
          select opt in $ss_menu
          do
            ss_name=`echo $opt|gawk -F':' '{print $2}'|sed -e 's/ //g'`
	    echo -ne "Please choose new snapshot name: "
            read new_name
            VBoxManage snapshot $vm edit ${ss_name} --name ${new_name}
            [ -n "$ss_name" ] && break
          done
          [ -n "$vm" ] && break
        done
        IFS=$OLD_IFS
;;
listss)
        vm_menu=`vm_list`
        OLD_IFS=$IFS
        IFS=$(echo -ne "\n\r")
        PS3="Please select vm: "
        select opt in $vm_menu
        do
          vm=`echo $opt|gawk -F':' '{print $1}'`
          echo "your select is: $vm"
          $VBOXMAN snapshot $vm list|grep Name|gawk -F'(' '{print $1}'|sed -e 's/Name: //g'
          [ -n "$vm" ] && break
        done
        IFS=$OLD_IFS
;;
*)
        USAGE
        exit 253
;;
esac

