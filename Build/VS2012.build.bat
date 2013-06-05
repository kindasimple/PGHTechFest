@echo off

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP 

if not exist "%VS110COMNTOOLS%" goto MissingCOMNTOOLS
REM if "%~1"=="" goto MissingSOLUTION
REM if not exist %1 goto MissingSOLUTION

echo loading configuration %~dp0VS2012.build-config.cmd
call %~dp0VS2012.build-config.cmd

if "%~1" NEQ "" set Solution_Path=%1

SET Config="%~2"
if "%~2"=="" set Config="Debug"
if [%2]==[] set Config="Debug"

set Platform="%~3"
if "%~3"=="" set Platform="x86"
if [%3]==[] set Platform="x86"

set Feature="%~4"
if "%~4"=="" set Feature="Demo"
if [%4]==[] set Feature="Demo"

echo   Solution path %Solution_Path%
echo   Selected Configuration %Config%
echo   Selected Platform %Platform%
echo   Selected Feature %Feature%
echo.

:BuildSolution

call "%VS110COMNTOOLS%vsvars32.bat"

:DoBuild

echo Build solution %Solution_Path%
if %Feature% NEQ "" mkdir %Feature%

SET Error=0

if %Platform%=="ALL" (
   CALL :BUILD %Solution_Path% %Config% ARM %Feature%
   CALL :BUILD %Solution_Path% %Config% x86 %Feature%
   CALL :BUILD %Solution_Path% %Config% x64 %Feature%
   
) else (
   CALL :BUILD %Solution_Path% %Config% %Platform% %Feature%
)
if %Error% neq 0 Exit /B %Error%


GOTO:EOF

REM =====================================================================
REM = NOTIFY - indicate failure
REM =====================================================================
:NOTIFY
echo Error occurred with code %~1
CALL :SPEAK "Error occurred with code %~1"
SET Error=%~1
EXIT /B


REM =====================================================================
REM = SPEAK - vocalize command
REM =====================================================================
:SPEAK
where nircmd.exe /Q
if %errorlevel% neq 0 ( 
echo %~1 
) else (
nircmd speak text "%~1" 2 60
)
EXIT /B

REM =====================================================================
REM = BUILD - run MSBuild against configuration
REM =====================================================================
:BUILD
ECHO Building for %~3
CALL :SPEAK "Building for %~3"
msbuild %~1 /nologo /m /consoleloggerparameters:ErrorsOnly /p:Configuration=%~2 /p:Platform="%~3" /p:SourceBranchTag=%~4 /p:AppxPackageDir="%~dp0/../../AppPackages/" /p:AppxDropFolderPath="" /p:CustomAfterMicrosoftCommonTargets="" /fileLogger /flp:logfile="%~4/%date:~10,4%%date:~4,2%%date:~7,2%_%~2_%~3.log"
if %errorlevel% neq 0 CALL :NOTIFY %errorlevel%
REM Add to an installation scripts
EXIT /B

:MissingCOMNTOOLS
echo Visual studio default location was not found...
echo Script terminated: %VS110COMNTOOLS% does not exist
pause
GOTO:EOF

:MissingCOMNTOOLS
echo Visual studio default location was not found...
echo Script terminated: %VS110COMNTOOLS% does not exist
pause
GOTO:EOF

:MissingSOLUTION
echo Solution file is required for building...
echo Script terminated: %Solution_Path% does not exist
echo Example: call "VS2012.build.bat" "PGHTechFest/PGHTechFest.sln" "Release" "ARM" "master"
pause
GOTO:EOF

:HELP
echo   Build solution
echo.   
echo    VS2012.build.cmd [solution filepath]
GOTO:EOF