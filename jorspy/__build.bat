@echo off
pushd "%~dp0"
node ..\..\QBC\QBC.js c jorspy.q -g gh3 -o ..\jorspy.qb.xen
mkdir !cache > NUL
imggen *.png
del jorspy_*_0.img.xen /q
copy *.img.xen !cache /y
del *.img.xen
mkfonts
copy *.fnt.xen !cache /y
del *.fnt.xen /q
set "OUT=..\..\..\DATA\MODS\"
..\..\pakdir !cache ..\jorspy
copy ..\jorspy.qb.xen "%OUT%" /y
copy ..\jorspy.pak.xen "%OUT%" /y
popd
