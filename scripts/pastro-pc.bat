@echo off
:: ========================================================
:: Krijuar nga MR ERIONXX
:: (c) 2026 MR ERIONXX - Te gjitha te drejtat e rezervuara
:: Perdorim i lire vetem me ruajtjen e ketij krediti.
:: Ndalohet heqja e krediti dhe pretendimi si autor i huaj.
:: Shih LICENSE.md ne projekt per kushtet e plota.
:: ========================================================
title SUPER PREMIUM - Pastro dhe Pershpejto PC
color 0b
:: ============================================================
::  SUPER PREMIUM PC BOOSTER
::  Pastrim i thelle + optimizim + tweaks shpejtese
::  Kliko me te djathte -> "Run as administrator"
::  Perdore 1 here ne muaj.
:: ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  !!! KERKOHET "Run as administrator" !!!
    echo  Kliko me te djathte mbi kete file -^> Run as administrator.
    echo.
    pause
    exit /b
)

echo.
echo  ========================================================
echo   SUPER PREMIUM PC BOOSTER - po fillon...
echo  ========================================================
echo.

echo  [Hapesira e lire ne C: PARA pastrimit]
wmic logicaldisk where "DeviceID='C:'" get FreeSpace /format:value 2>nul | find "="
echo.

echo  [1/9] Pastrim i thelle TEMP + Prefetch...
del /q /f /s "%TEMP%\*" 2>nul
del /q /f /s "C:\Windows\Temp\*" 2>nul
del /q /f /s "C:\Windows\Prefetch\*" 2>nul
echo  OK.
echo.

echo  [2/9] Pastrim i cache-it te Windows Update...
net stop wuauserv >nul 2>&1
del /q /f /s "C:\Windows\SoftwareDistribution\Download\*" 2>nul
net start wuauserv >nul 2>&1
echo  OK.
echo.

echo  [3/9] Pastrim thumbnail cache + log-e te vjetra...
del /q /f /s "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
del /q /f "C:\Windows\Logs\CBS\*.log" 2>nul
echo  OK.
echo.

echo  [4/9] Zbrazje e Recycle Bin...
rd /s /q "C:\$Recycle.Bin" 2>nul
echo  OK.
echo.

echo  [5/9] Pastrim i komponenteve te vjeter te Windows (DISM)...
DISM /Online /Cleanup-Image /StartComponentCleanup
echo.

echo  [6/9] Optimizim i diskut C:...
defrag C: /O
echo.

echo  [7/9] Tweaks SUPER PREMIUM te shpejtesise...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
sc config sysmain start=disabled >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 01 /t REG_DWORD /d 1 /f >nul
echo  OK - 5 tweaks u aplikuan:
echo    - Menyte hapen menjehere (0ms)
echo    - Hiqet vonesa e programeve ne ndezje
echo    - Efektet vizuale perhere ne "Best performance"
echo    - SysMain i ndaluar perhere (s'e ngadaleson diskun)
echo    - Storage Sense aktiv (pastrim automatik)
echo.

echo  [8/9] Pastrim DNS cache...
ipconfig /flushdns
echo.

echo  [9/9] Verifikim i shpejte i file-ve te sistemit...
sfc /verifyonly
echo.

echo  [Hapesira e lire ne C: PAS pastrimit]
wmic logicaldisk where "DeviceID='C:'" get FreeSpace /format:value 2>nul | find "="
echo.

if /i "%1"=="/auto" goto SKIPAV
set /p AVSCAN="Don skanim te shpejte antivirus tani? (Y/N): "
if /i "%AVSCAN%"=="Y" (
    echo Po fillon skanimi i shpejte Defender...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
)
:SKIPAV

echo.
echo  ========================================================
echo   U KRYE! PC-ja eshte pastruar dhe optimizuar.
echo   Bej RESTART per te aktivizuar te gjitha tweaks.
echo  ========================================================
if /i "%1"=="/auto" exit /b
pause
