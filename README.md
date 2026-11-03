# Mirembajtje Windows — nga MR ERIONXX

<!-- Created by Erion Nezha — © 2026 All rights reserved -->

Skripte `.bat` për pastrimin, optimizimin dhe mirëmbajtjen e Windows 10.
Të tre skriptet janë krijuar nga **MR ERIONXX** dhe kërkojnë të drejta
Administratori. Pas ekzekutimit, bëni **Restart** për të aplikuar të gjitha
ndryshimet.

> Përdorim i lirë, vetëm me ruajtjen e krediti. Shih `LICENSE.md`.
> Ndalohet heqja e emrit të autorit dhe pretendimi i projektit si i juaji.

## Struktura

```
mirembajtje-windows/
├── README.md
├── LICENSE.md
└── scripts/
    ├── Mirembajtje_Laptopi.bat   # niveli 1 — më i buti
    ├── Optimizim_Total.bat       # niveli 2 — mesatar
    └── Super_Optimizim.bat       # niveli 3 — më agresivi
```

Zgjidh **një** nivel sipas nevojës. Mos i ekzekutoni të tre njëri pas tjetrit
pa arsye, sepse hapat e tyre mbivendosen (pastrim Temp, Defender, etj.).

## Kërkesat

- Windows 10 (komandat bazë punojnë edhe në Windows 11, por projekti është
  menduar dhe emërtuar për Windows 10)
- Të drejta Administratori — skripti i kërkon vetë, nëse nuk e nisni si Admin
- Lidhje interneti për DISM `/Restorehealth` dhe për përditësimin e
  Windows Defender
- Kohë: pastrimi është i shpejtë, por DISM + SFC mund të zgjasin
  15–30 minuta dhe skanimi i plotë i Defender-it edhe më gjatë

## 1. Mirembajtje_Laptopi.bat — niveli i butë, për mirëmbajtje të rregullt

Ky është skripti për përdorim të përditshëm / javor, pa prekur startup-in,
shërbimet apo planin e energjisë.

1. **Pastrim i skedarëve të panevojshëm** — `%TEMP%`, `C:\Windows\Temp`,
   `Prefetch`, Recycle Bin dhe mbetjet e shkarkimeve të Windows Update
   (`SoftwareDistribution\Download`, me ndalim/rinisje të shërbimit `wuauserv`)
2. **Optimizim rrjeti** — `ipconfig /flushdns` dhe `netsh winsock reset`
3. **Kontroll dhe riparim i sistemit** — `DISM /Online /Cleanup-image /Restorehealth`
   dhe pastaj `sfc /scannow`
4. **Skanim i thellë antivirus** — përditësim i nënshkrimeve të
   Windows Defender (`MpCmdRun -SignatureUpdate`) dhe skanim i plotë
   (`MpCmdRun -Scan -ScanType 2`)

Përdoreni kur laptopi ngec, por nuk doni të ndryshoni cilësime të sistemit.

## 2. Optimizim_Total.bat — niveli mesatar, për shpejtësi ndezjeje

Shton mbi pastrimin edhe optimizimin e startup-it dhe të energjisë.
**Nuk** bën DISM/SFC dhe nuk bën `winsock reset`.

1. **Pastrim** — Temp, `C:\Windows\Temp`, Prefetch, Recycle Bin,
   mbetje Windows Update dhe `ipconfig /flushdns`
2. **Çaktivizim aplikacionesh dhe shërbimesh në sfond** — bllokon
   aplikacionet në sfond të Windows, ndalon shërbimet e telemetrisë
   (`DiagTrack`, `dmwappushservice`), `MapsBroker` dhe shërbimet Xbox
   (vendosen në `demand`, jo të çaktivizuara plotësisht)
3. **Pastrim i startup-it** — heq nga `Run` (HKCU/HKLM):
   OneDrive, Spotify, Skype, Steam, Discord, Teams, MicrosoftEdgeAutoLaunch,
   iTunesHelper
4. **Plani Ultimate Performance** — krijon dhe aktivizon planin
   `e9a42b02-d5df-448d-aa00-03f14749eb61`
5. **Skanim i thellë antivirus** — si te niveli 1, Defender full scan

Përdoreni kur ndezja është e ngadaltë dhe ka shumë programe që hapen vetë.

## 3. Super_Optimizim.bat — niveli agresiv, vetëm kur duhet

Ky është kombinimi më i plotë dhe më agresiv. Përdoreni rrallë,
dhe vetëm pasi të keni kuptuar paralajmërimet më poshtë.

1. **Lirimi i skedarëve të bllokuar** — rinis `explorer.exe` për të liruar
   skedarët e bllokuar
2. **Pastrim i thellë** — si niveli 1, plus `ipconfig /flushdns`
   dhe `netsh winsock reset`
3. **Startup dhe shërbime në sfond** — si niveli 2, plus:
   - vonesa e startup-it vendoset në 0
   - `Fax` çaktivizohet plotësisht, shërbimet Xbox vendosen në `demand`
   - hiqen edhe të gjitha shkurtoret `.lnk` nga dosja Startup e përdoruesit
4. **Shpejtësi maksimale** — plani Ultimate Performance dhe
   optimizim disku `defrag C: /O` (TRIM për SSD / optimizim për HDD)
5. **Riparim sistemi** — DISM `/Restorehealth` + `sfc /scannow`
6. **Skanim i thellë antivirus** — **heq të gjitha përjashtimet
   (exclusions) e Defender-it** para skanimit, pastaj përditësim
   nënshkrimesh dhe skanim i plotë

### Paralajmërime për Super_Optimizim

- Heqja e shkurtoreve nga Startup do të thotë që programet që i keni
  vendosur vetë të hapen me Windows **nuk do të hapen më vetë** —
  do t'i hapni manualisht.
- Heqja e përjashtimeve të Defender-it do të thotë që dosjet/programet
  që i keni përjashtuar qëllimisht **do të skanohen sërish** dhe mund
  të bllokohen.
- Çaktivizimi i `Fax` dhe `MapsBroker` është i sigurt vetëm nëse nuk
  i përdorni ato shërbime.

## Si përdoret

1. Shkarkoni dosjen `scripts/` ose vetëm skriptin që ju duhet.
2. Klikoni me të djathtën mbi `.bat` → **Run as administrator**
   (nëse e hapni me dopio-klik, skripti e kërkon vetë Adminin dhe rihapet).
3. Prisni të përfundojë — **mos e mbyllni dritaren** gjatë DISM/SFC
   dhe skanimit të Defender-it.
4. Bëni **Restart** kur skripti ta kërkojë në fund.

## Çfarë u sistemua në versionin publik

Krahasuar me skedarët origjinalë të autorit, versioni publik ka vetëm
dy ndryshime të domosdoshme, pa prekur logjikën e skripteve:

- **Super_Optimizim:** u hoq seksioni personal që fshinte një skedar
  specifik nga dosja `Downloads` e autorit
  (`C:\Users\<emri-i-përdoruesit>\...`).
  Versioni publik është i përgjithshëm dhe nuk përmban asnjë rrugë
  personale dhe nuk fshin skedarë të përdoruesit.
- **Optimizim_Total:** u rregullua bug-u i `powercfg` — përdorej
  `tokens=2`, që nuk e kap GUID-in e planit. Tani është `tokens=4`,
  si te Super_Optimizim, që është forma e saktë
  (`Power Scheme GUID: <GUID>` → tokeni i 4-t).

Origjinalet e autorit nuk janë prekur; ato mbeten te ai.

## Mohim përgjegjësie

Skriptet jepen "siç janë", pa garanci. Ekzekutimi ndryshon cilësime
sistemi (startup, shërbime, plan energjie, përjashtime Defender).
Bëni backup të të dhënave të rëndësishme para se të ekzekutoni
veçanërisht Super_Optimizim. Autori nuk mban përgjegjësi për humbje
të dhënash nga përdorimi pa lexuar paralajmërimet.

---

**Krijuar nga MR ERIONXX — © 2026 All rights reserved.**
