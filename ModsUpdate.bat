@echo off

setlocal enabledelayedexpansion
set /p dir="Minecraft directory: "
echo Checking directory...
mkdir workingDir

if not exist "%dir%\assets" (
	echo Invalid minecraft directory entered!
	echo Minecraft did not install or Wrong directory given.
	goto :stop
)
if not exist "%dir%\versions\1.19.2-forge-43.2.0" (
    echo There is no mods folder! Did you install Forge?
	:prompt
    set /p ans="Do you want to install Forge now?(Y/N)"
    if /i "%ans%"=="Y" (
        curl -L -o workingDir/forge.jar https://maven.minecraftforge.net/net/minecraftforge/forge/1.19.2-43.2.0/forge-1.19.2-43.2.0-installer.jar
        java -jar workingDir/forge.jar
		curl -L -o workingDir/mods.zip https://www.dropbox.com/s/5ag6fqz2hiz9qdq/mods.zip?dl=1
		CALL :Extract "%dir%\mods" "%~dp0\workingDir\mods.zip"
		goto :stop
    ) 
	if /i "%ans%" =="N" (
        goto :stop
    )
	else(
		echo Invalid input. Enter Y or N only.
		goto :prompt
)
curl -L -o workingDir/mods.zip https://www.dropbox.com/s/5ag6fqz2hiz9qdq/mods.zip?dl=1
curl -L -o workingDir/ModList.txt https://www.dropbox.com/s/nei4j5kyjhcub5o/ModList.txt?dl=1
CALL :Extract "%~dp0\workingDir" "%~dp0\workingDir\mods.zip"
echo Extraction complete.

set filename="workingDir\ModList.txt"

for /f "tokens=* delims=" %%a in ('type "%filename%"') do (
	set filepath=%dir%\mods\%%a
	set target=%~dp0\workingDir\%%a
	if exist "!filepath!" (
		echo %%a is exist.
	) else (
		move "!target!" "%dir%\mods"
	)
)

rmdir /s /q "%~dp0\workingDir"
echo Update Done!
pause
goto :eof

:Extract <Destination> <ZipFile>
powershell -Command "Expand-Archive -Path '%2' -DestinationPath '%1' -Force"
goto :eof

:stop
echo Installation stopped.
rmdir /s /q "%~dp0\workingDir"
pause
goto :eof

