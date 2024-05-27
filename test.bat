@echo off
pushd "%~dp0"
call build_all
set GAMEDIR=..\..\..
start "" /D "%GAMEDIR%" "%GAMEDIR%\game!"
popd