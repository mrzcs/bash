bash scripts
============
Hello everyone, 

This repository includes bash scripts I made and used in my daily work. Please feel free to use them. 

Comments and advise are always welcome.

-------------------------------------------------------------------------------------------------------

1. vmcontrol.sh

The script is used to manage virtual machines of VBox, including starting, listing and stopping vms plus creating, deleting, restoring, renaming and listing snapshot. Both Linux and Windows platform are supported. In Windows, cygwin is required.

VMS is started using headless mode. So vms will keep running even in case user logged out by incident.

Usage: vmcontrol.sh {startvm|stopvm|listvm|takess|deletess|listss|resotress|renamess}
