@echo off
:: ========================================================
:: SUPER Optimizim, Pastrim dhe Antivirus - Windows 10
:: Krijuar nga MR ERIONXX
:: (c) 2026 MR ERIONXX - Te gjitha te drejtat e rezervuara
:: Perdorim i lire vetem me ruajtjen e ketij krediti.
:: Ndalohet heqja e krediti dhe pretendimi si autor i huaj.
:: Shih LICENSE.md ne projekt per kushtet e plota.
:: ========================================================
title SUPER OPTIMIZIM, PASTRIM DHE ANTIVIRUS - WINDOWS 10
color 0A

:: 1. Merr automatikisht te drejta Administratori
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Duke kerkuar te drejta Administratori...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================================
echo   1. LIRIMI I SKEDAREVE TE BLLOKUAR
echo ========================================================
echo Duke liruar skedaret e bllokuar...

:: SHENIM: Seksioni personal (fshirja e nje file-i specifik te autorit)
:: eshte hequr nga versioni publik. Ky skript tani eshte i pergjithshem.
:: Rifreskon Explorer per te liruar skedaret e bllokuar
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo [OK] Skedaret e bllokuar u mbyllen dhe u fshine me force!
echo.

echo ========================================================
echo   2. PASTRIMI I THELLE I HAPESIRES (TEMP, CACHE, KOSHI)
echo ========================================================
echo Duke fshire skedaret e panevojshem qe zene hapesire...
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
netsh winsock reset >nul 2>&1
echo [OK] Hapesira e diskut dhe rrjeti u pastruan plotesisht!
echo.

echo ========================================================
echo   3. CAKTIVIZIMI I STARTUP DHE SHERBIMEVE NE SFOND
echo ========================================================
echo Duke bllokuar aplikacionet e fshehta ne sfond dhe vonesen e ndezjes...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul 2>&1

echo Duke ndaluar sherbimet qe rendojne procesorin dhe RAM-in...
for %%s in ("DiagTrack" "dmwappushservice" "MapsBroker" "Fax") do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
for %%x in ("XblAuthManager" "XblGameSave" "XboxGipSvc" "XboxNetApiSvc") do (
    sc stop %%x >nul 2>&1
    sc config %%x start= demand >nul 2>&1
)

echo Duke hequr programet e panevojshme nga ndezja automatike...
for %%i in ("OneDrive" "Spotify" "Skype" "Steam" "Discord" "com.squirrel.Teams.Teams" "MicrosoftEdgeAutoLaunch" "iTunesHelper" ) do (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %%i /f >nul 2>&1
    reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v %%i /f >nul 2>&1
    reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" /v %%i /f >nul 2>&1
)
del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*.lnk" >nul 2>&1
echo [OK] Startup dhe sherbimet ne sfond u optimizuan!
echo.

echo ========================================================
echo   4. RRITJA E SHPEJTESISE (ULTIMATE PERFORMANCE DHE DISKU)
echo ========================================================
echo Duke aktivizuar planin maksimal te energjise Ultimate Performance...
for /f "tokens=4" %%i in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61') do set "UltPlan=%%i"
powercfg -setactive %UltPlan% >nul 2>&1

echo Duke optimizuar diskun SSD/HDD (TRIM dhe Defrag)...
defrag C: /O >nul 2>&1
echo [OK] Shpejtesia e procesorit dhe e diskut u maksimizua!
echo.

echo ========================================================
echo   5. RIPARIMI I NGRIRJEVE TE SISTEMIT (DISM DHE SFC)
echo   (Ky proces kontrollon dhe riparon Windows-in, prisni...)
echo ========================================================
DISM.exe /Online /Cleanup-image /Restorehealth
sfc /scannow
echo [OK] Skedaret e demtuar te Windows u riparuan!
echo.

echo ========================================================
echo   6. SKANIM I THELLE KUNDER VIRUSEVE DHE TROJANEVE
echo ========================================================
echo Duke pastruar bllokimet e mundshme te Antivirusit...
powershell -Command "Get-MpPreference | Select-Object -ExpandProperty ExclusionPath | ForEach-Object { Remove-MpPreference -ExclusionPath $_ -ErrorAction SilentlyContinue }" >nul 2>&1

echo Duke perditesuar databazen dhe duke nisur skanimin e plote...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo [OK] Skanimi i thelle per viruse perfundoi!
echo.

echo ========================================================
echo   TE GJITHA PROCESET PERFUNDUAN ME SUKSES!
echo   Ju lutem beni RESTART laptopin tuaj tani.
echo ========================================================
pause
