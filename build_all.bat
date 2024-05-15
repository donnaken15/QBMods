@echo off
for %%Q in (*.q) do node ..\QBC\QBC.js c "%%Q" -g gh3

:: stuff i need to test
for %%A in (
	eval
	FPS_display
	whammy_120FPS
) do copy "%%A.qb.xen" "..\..\..\DATA\MODS\%%A.qb.xen" /y >nul

jorspy\__build
copy "jorspy.pak.xen" "..\..\DATA\MODS" /y
copy "jorspy.qb.xen" "..\..\DATA\MODS" /y

