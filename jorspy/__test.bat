@echo off
pushd "%~dp0"
call __build
set "GAME=..\..\..\..\"
copy "..\jorspy.pak.xen" "%GAME%DATA\MODS\" /y
copy "..\jorspy.qb.xen" "%GAME%DATA\MODS\" /y
start /D "%GAME%" "" "%GAME%game!"
popd
