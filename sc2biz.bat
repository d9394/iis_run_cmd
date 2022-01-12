@echo off
setlocal EnableDelayedExpansion
set filedate=%date:~0,4%%date:~5,2%%date:~8,2%
if exist "Q:\Cluster\0.hive" (
  rsync.exe  -v -rlt -z --chmod=a=rw,Da+x --delete --include-from=include_file.txt --exclude=* -p --chmod=ugo=rwX "/cygdrive/R/SC2BIZ/" "xxxx@192.168.1.4::SC2BIZ/"  --log-file="/cygdrive/C/Program Files (x86)/DeltaCopyRaw/log/sc2biz_%filedate%.log"
)
