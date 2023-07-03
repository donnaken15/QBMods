@echo off
sh ../../../qcomp . ../../../../../DATA/MODS/disabled
mkdir !cache > NUL
imggen *.png
del jorspy_text*.img.xen
move *.img.xen !cache
bmfont4ns jorspy_text1.fnt
move bmf_test.fnt !cache\text_jorspy1.fnt.xen
bmfont4ns jorspy_text2.fnt
move bmf_test.fnt !cache\text_jorspy2.fnt.xen
node "E:\GHWTDE\guitar-hero-sdk\sdk.js" createpak -out ..\..\..\..\..\DATA\MODS\disabled\jorspy.pak.xen !cache

