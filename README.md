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

Examples:

a. list vms
D:\vm>bash vmcontrol.sh listvm
ocm11g_even:stop
ocm11g_odd:stop
oel54_112_32bit:running
sol10_oracle10201:stop
sol10_oracle10202:stop
sol10_oracle11201:stop

b. start vms
D:\vm>bash vmcontrol.sh startvm
1) ocm11g_even:stop        4) sol10_oracle10201:stop
2) ocm11g_odd:stop         5) sol10_oracle10202:stop
3) oel54_112_32bit:stop    6) sol10_oracle11201:stop
Please select vm: 3
your select is: oel54_112_32bit
Waiting for VM "oel54_112_32bit" to power on...
VM "oel54_112_32bit" has been successfully started.

c. stop vms
D:\vm>bash vmcontrol.sh stopvm
1) ocm11g_even:stop         4) sol10_oracle10201:stop
2) ocm11g_odd:stop          5) sol10_oracle10202:stop
3) oel54_112_32bit:running  6) sol10_oracle11201:stop
Please select vm: 3
your select is: oel54_112_32bit
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%

d. list snapshot
D:\vm>bash vmcontrol.sh listss
1) ocm11g_even:stop        4) sol10_oracle10201:stop
2) ocm11g_odd:stop         5) sol10_oracle10202:stop
3) oel54_112_32bit:stop    6) sol10_oracle11201:stop
Please select vm: 1
your select is: ocm11g_even
   00_soft_ready
      01_gc_soft_ready
         02_gc_agent_ready
         
e. restore snapshot
D:\vm>bash vmcontrol.sh restoress
1) ocm11g_even:stop        4) sol10_oracle10201:stop
2) ocm11g_odd:stop         5) sol10_oracle10202:stop
3) oel54_112_32bit:stop    6) sol10_oracle11201:stop
Please select vm: 1
your select is: ocm11g_even
1)    Name: 00_soft_ready             3)          Name: 02_gc_agent_ready
2)       Name: 01_gc_soft_ready
Please select snapshot name to restore:
        

