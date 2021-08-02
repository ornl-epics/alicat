#!../../bin/linux-x86_64/alicat

## You may have to change alicat to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/alicat.dbd"
alicat_registerRecordDeviceDriver pdbbase


#asynSetAutoConnectTimeout(1.0)
drvAsynIPPortConfigure( "alicat1", "10.112.36.51:4002 tcp", 0, 0, 0 )

#enables debugging 0xff is the max setting
asynSetTraceIOMask("alicat1", 0,0xff)
asynSetTraceMask("alicat1", 0,0xff)




## Load record instances
dbLoadRecords("db/Alicat.db")
#################################################
# autosave

epicsEnvSet IOCNAME SE-SE-Alicat
epicsEnvSet SAVE_DIR /home/controls/var/$(IOCNAME)

save_restoreSet_Debug(0)

### status-PV prefix, so save_restore can find its status PV's.
save_restoreSet_status_prefix("SE:SE:Alicat:")

set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")

save_restoreSet_NumSeqFiles(1)
save_restoreSet_SeqPeriodInSeconds(600)
set_pass1_restoreFile("$(IOCNAME).sav")

#################################################



cd ${TOP}/iocBoot/${IOC}
iocInit


# Create request file and start periodic 'save'
epicsThreadSleep(5)
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME).req", "autosaveFields")
create_monitor_set("$(IOCNAME).req", 5)

