@echo off
:: ========================================================
:: Optimizim Total - Pastrim, Performance dhe Skanim - Windows 10
:: Krijuar nga MR ERIONXX
:: (c) 2026 MR ERIONXX - Te gjitha te drejtat e rezervuara
:: Perdorim i lire vetem me ruajtjen e ketij krediti.
:: Ndalohet heqja e krediti dhe pretendimi si autor i huaj.
:: Shih LICENSE.md ne projekt per kushtet e plota.
:: ========================================================
title Optimizimi Total i Windows 10 - Pastrim, Performance dhe Skanim
color 0A

:: Kërkon automatikisht të drejta Administratori
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Duke kerkuar te drejta Administratori...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================================
echo   1. PASTRIMI I SKEDAREVE TE PANEVOJSHME DHE CACHE
echo ========================================================
echo Duke fshire skedaret Temp, Prefetch dhe Koshin...
del /q /f /s "%TEMP%\*" >nul 2>&1
rd /s /q "%TEMP%" >nul 2>&1
md "%TEMP%" >nul 2>&1

del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
rd /s /q "C:\Windows\Temp" >nul 2>&1
md "C:\Windows\Temp" >nul 2>&1

del /q /f /s "C:\Windows\Prefetch\*" >nul 2>&1
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

net stop wuauserv >nul 2>&1
del /q /f /s "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1
net start wuauserv >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo [OK] Pastrimi u krye me sukses!
echo.

echo ========================================================
echo   2. ÇAKTIVIZIMI I APLIKACIONEVE DHE SHERBIMEVE NE SFOND
echo ========================================================
echo Duke bllokuar aplikacionet ne sfond te Windows...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1

echo Duke ndaluar sherbimet e telemetrise dhe Xbox...
sc stop "DiagTrack" >nul 2>&1
sc config "DiagTrack" start= disabled >nul 2>&1
sc stop "dmwappushservice" >nul 2>&1
sc config "dmwappushservice" start= disabled >nul 2>&1
sc stop "MapsBroker" >nul 2>&1
sc config "MapsBroker" start= disabled >nul 2>&1
sc stop "XblAuthManager" >nul 2>&1
sc config "XblAuthManager" start= demand >nul 2>&1
sc stop "XblGameSave" >nul 2>&1
sc config "XblGameSave" start= demand >nul 2>&1

echo Duke pastruar programet e panevojshme nga Startup...
for %%i in ("OneDrive" "Spotify" "Skype" "Steam" "Discord" "com.squirrel.Teams.Teams" "MicrosoftEdgeAutoLaunch" "iTunesHelper") do (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %%i /f >nul 2>&1
    reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v %%i /f >nul 2>&1
)
echo [OK] Startup dhe sherbimet u optimizuan!
echo.

echo ========================================================
echo   3. AKTIVIZIMI I PLANIT ULTIMATE PERFORMANCE
echo ========================================================
for /f "tokens=4" %%i in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61') do set "UltPlan=%%i"
powercfg -setactive %UltPlan% >nul 2>&1
echo [OK] Plani Ultimate Performance u aktivizua!
echo.

echo ========================================================
echo   4. SKANIM I THELLE PER VIRUSE DHE TROJANE
echo ========================================================
echo Po perditesohet databaza e Windows Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
echo Po niset skanimi i plote i diskut (kjo mund te marre kohe)...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo [OK] Skanimi per viruse perfundoi!
echo.

echo ========================================================
echo   TE GJITHA PROCESET PERFUNDUAN ME SUKSES!
echo   Rinisni laptopin tuaj per te aplikuar te gjitha ndryshimet.
echo ========================================================
pause
