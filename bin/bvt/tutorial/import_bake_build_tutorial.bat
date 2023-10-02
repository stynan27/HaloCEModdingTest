@echo off
pushd %~dp0

SET TOOL_EXE=tool
SET CACHE_FILE_PLATFORM=classic
REM Required to make a truely standalone map, i.e. all resources are contained within tutorial.map itself
REM 'none' is technically the default value, but we explicitly state it to drive the point home.
SET RESOURCE_MAP_USAGE=none

cd ..\..\..\

ECHO Marking tutorial.scenario_structure_bsp as writable and importing its JMS
attrib -r tags\levels\test\tutorial\tutorial.scenario_structure_bsp
%TOOL_EXE% structure levels\test\tutorial tutorial
IF NOT '%ERRORLEVEL%'=='0' GOTO ERROR

ECHO(
ECHO(
REM Technically, lightmaps also requires the scenario_structure_bsp to be writable but we already did that above
ECHO Marking tutorial.bitmap (lightmap) as writable and rebaking the level's lightmap
attrib -r tags\levels\test\tutorial\tutorial.bitmap
%TOOL_EXE% lightmaps levels\test\tutorial\tutorial tutorial 1 0.6
IF NOT '%ERRORLEVEL%'=='0' GOTO ERROR

ECHO(
ECHO(
ECHO Building a standalone tutorial.map
%TOOL_EXE% build-cache-file levels\test\tutorial\tutorial %CACHE_FILE_PLATFORM% %RESOURCE_MAP_USAGE%
IF NOT '%ERRORLEVEL%'=='0' GOTO ERROR

ECHO(
ECHO(
ECHO Finished processing tutorial level
GOTO THE_END

:ERROR
ECHO "!ERROR! %ERRORLEVEL%"
ECHO Failed processing the tutorial level, haulting entire batch process.
SET LOCAL_ERRORLEVEL=1
GOTO THE_END

:THE_END

popd

if %LOCAL_ERRORLEVEL% == 1 (
    ECHO Failed!
    EXIT /B 1
) else (
    ECHO Succeeded!
    EXIT /B 0
)
