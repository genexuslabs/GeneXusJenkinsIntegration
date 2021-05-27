@echo off
setlocal
:set "headerLine=/////////////////////////////////////////////////////////////////"
set "headerLine=-----------------------------------------------------------------"

echo %headerLine%
echo -- Execution Parameters
echo %headerLine%

echo Force Rebuild : %ForceRebuild% 
echo Run Tests     : %runTests%
echo.
echo.

echo %headerLine%
echo -- Genexus Installation
echo %headerLine%

echo Name : %gxInstallationId%
echo Path : %genexus%
echo.

"%genexus%\\genexus" /version
echo.
echo.

