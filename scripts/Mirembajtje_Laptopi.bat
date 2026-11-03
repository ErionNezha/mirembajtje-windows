@echo off
:: ========================================================
:: Mirembajtje Laptopi - Pastrim, Riparim dhe Skanim i Thelle - Windows 10
:: Krijuar nga MR ERIONXX
:: (c) 2026 MR ERIONXX - Te gjitha te drejtat e rezervuara
:: Perdorim i lire vetem me ruajtjen e ketij krediti.
:: Ndalohet heqja e krediti dhe pretendimi si autor i huaj.
:: Shih LICENSE.md ne projekt per kushtet e plota.
:: ========================================================
title Pastrim, Riparim dhe Skanim i Thelle - Windows 10
color 0A

:: Kërkon automatikisht të drejta Administratori kur hapet
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Duke kerkuar te drejta Administratori...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================================
echo   1. FSHIRJA E SKEDAREVE TE PANEVOJSHME (TEMP DHE CACHE)
echo ========================================================
echo Duke fshire skedaret e perkohshem te perdoruesit...
del /q /f /s "%TEMP%\*" >nul 2>&1
rd /s /q "%TEMP%" >nul 2>&1
md "%TEMP%" >nul 2>&1

echo Duke fshire skedaret e perkohshem te Windows...
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
rd /s /q "C:\Windows\Temp" >nul 2>&1
md "C:\Windows\Temp" >nul 2>&1

echo Duke pastruar Prefetch...
del /q /f /s "C:\Windows\Prefetch\*" >nul 2>&1

echo Duke zbrazur Recycle Bin...
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

echo Duke pastruar mbetjet e Windows Update...
net stop wuauserv >nul 2>&1
del /q /f /s "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1
net start wuauserv >nul 2>&1

echo [OK] Hapesira u lirua me sukses!
echo.

echo ========================================================
echo   2. OPTIMIZIMI I RRJETIT DHE MEMORIES
echo ========================================================
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
echo [OK] Cache e rrjetit u pastrua!
echo.

echo ========================================================
echo   3. KONTROLLI DHE RIPARIMI I SISTEMIT KUNDER NGRIRJEVE
echo   (Ky proces mund te zgjase 15-30 minuta, mos e mbyllni)
echo ========================================================
DISM.exe /Online /Cleanup-image /Restorehealth
sfc /scannow
echo [OK] Kontrolli dhe riparimi i skedareve te sistemit perfundoi!
echo.

echo ========================================================
echo   4. SKANIM I THELLE PER VIRUSE DHE TROJANE
echo   (Po perditesohet databaza dhe po niset skanimi i plote)
echo ========================================================
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo [OK] Skanimi i thelle per viruse perfundoi!
echo.

echo ========================================================
echo   TE GJITHA PROCESET PERFUNDUAN ME SUKSES!
echo   Ju lutem beni RESTART laptopin tuaj per te aplikuar ndryshimet.
echo ========================================================
pause
