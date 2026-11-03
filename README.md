# Mirembajtje Windows | Windows Maintenance — nga / by MR ERIONXX

<!-- Created by Erion Nezha — © 2026 All rights reserved -->

[Shqip](#shqip) | [English](#english)

> **Shënim / Note:** Skriptet `.bat` mbeten fiks siç janë lënë — me mesazhet
> në shqip, pa asnjë ndryshim në komanda. README dhe LICENSE janë dygjuhësh.
> The `.bat` scripts remain exactly as originally written — with messages
> in Albanian, no change to the commands. README and LICENSE are bilingual.

---

## Shqip

Skripte `.bat` për pastrimin, optimizimin dhe mirëmbajtjen e Windows 10.
Të tre skriptet janë krijuar nga **MR ERIONXX** dhe kërkojnë të drejta
Administratori. Pas ekzekutimit, bëni **Restart** për të aplikuar të gjitha
ndryshimet.

> Përdorim i lirë, vetëm me ruajtjen e krediti. Shih `LICENSE.md`.
> Ndalohet heqja e emrit të autorit dhe pretendimi i projektit si i juaji.

### Struktura

```
mirembajtje-windows/
├── README.md
├── GUIDE.md
├── LICENSE.md
├── scripts/
│   ├── Mirembajtje_Laptopi.bat   # niveli 1 — më i buti
│   ├── Optimizim_Total.bat       # niveli 2 — mesatar
│   ├── Super_Optimizim.bat       # niveli 3 — më agresivi
│   └── pastro-pc.bat             # pastrim mujor SUPER PREMIUM
└── tools/
    └── bej-zip-kod/
        ├── BEJ-ZIP-KOD.bat       # nisësi i mjetit ZIP
        └── bej-zip-kod.ps1       # ZIP vetëm me kod
```

Zgjidh **një** nivel sipas nevojës. Mos i ekzekutoni të tre njëri pas tjetrit
pa arsye, sepse hapat e tyre mbivendosen (pastrim Temp, Defender, etj.).

### Kërkesat

- Windows 10 (komandat bazë punojnë edhe në Windows 11, por projekti është
  menduar dhe emërtuar për Windows 10)
- Të drejta Administratori — skripti i kërkon vetë, nëse nuk e nisni si Admin
- Lidhje interneti për DISM `/Restorehealth` dhe për përditësimin e
  Windows Defender
- Kohë: pastrimi është i shpejtë, por DISM + SFC mund të zgjasin
  15–30 minuta dhe skanimi i plotë i Defender-it edhe më gjatë

### 1. Mirembajtje_Laptopi.bat — niveli i butë, për mirëmbajtje të rregullt

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

### 2. Optimizim_Total.bat — niveli mesatar, për shpejtësi ndezjeje

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

### 3. Super_Optimizim.bat — niveli agresiv, vetëm kur duhet

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

#### Paralajmërime për Super_Optimizim

- Heqja e shkurtoreve nga Startup do të thotë që programet që i keni
  vendosur vetë të hapen me Windows **nuk do të hapen më vetë** —
  do t'i hapni manualisht.
- Heqja e përjashtimeve të Defender-it do të thotë që dosjet/programet
  që i keni përjashtuar qëllimisht **do të skanohen sërish** dhe mund
  të bllokohen.
- Çaktivizimi i `Fax` dhe `MapsBroker` është i sigurt vetëm nëse nuk
  i përdorni ato shërbime.

### 4. pastro-pc.bat — pastrim mujor SUPER PREMIUM

Skript mujor (vetë skripti thotë "1 herë në muaj"), i ndryshëm nga tre
të parët: bën pastrim TEMP/Prefetch, cache Windows Update, thumbnail
cache, CBS log-e, Recycle Bin, `DISM /StartComponentCleanup`,
`defrag C: /O`, 5 tweaks (MenuShowDelay 0, StartupDelay 0,
VisualFX "Best performance", SysMain disabled, Storage Sense),
`ipconfig /flushdns` dhe `sfc /verifyonly`.
**Kujdes:** `sfc /verifyonly` vetëm verifikon, nuk riparon; skanimi
antivirus në fund është opsional dhe i shpejtë (`ScanType 1`), jo i plotë.
Dhe ndryshe nga tre të parët, ky skript **nuk e kërkon vetë Adminin**
— duhet nisur manualisht me Run as administrator, përndryshe ndalon.
Udhëzuesi i plotë, hap pas hapi: `GUIDE.md`.

### Mjet shtesë: bej-zip-kod — ZIP vetëm me kod

`tools/bej-zip-kod/` përmban `BEJ-ZIP-KOD.bat` + `bej-zip-kod.ps1`
(të dy bashkë, në dosjen rrënjë të projektit). Bën ZIP vetëm me kodin,
pa `data/`, `node_modules/`, `dist/`, `.git/`, pa `*.mp4`/`*.pyc`/`*.zip`,
me dalje në Desktop: `cmimradar-ndryshimet-kod.zip` (emri origjinal
për ÇmimRadar, i lënë siç ishte). Nëse ZIP-i del mbi 24 MB, skripti
vetë paralajmëron të mos e ngarkosh. Udhëzuesi i plotë: `GUIDE.md`.

### Si përdoret

1. Shkarkoni dosjen `scripts/` ose vetëm skriptin që ju duhet.
2. Klikoni me të djathtën mbi `.bat` → **Run as administrator**
   (nëse e hapni me dopio-klik, skripti e kërkon vetë Adminin dhe rihapet).
3. Prisni të përfundojë — **mos e mbyllni dritaren** gjatë DISM/SFC
   dhe skanimit të Defender-it.
4. Bëni **Restart** kur skripti ta kërkojë në fund.

### Çfarë u sistemua në versionin publik

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

### Mohim përgjegjësie

Skriptet jepen "siç janë", pa garanci. Ekzekutimi ndryshon cilësime
sistemi (startup, shërbime, plan energjie, përjashtime Defender).
Bëni backup të të dhënave të rëndësishme para se të ekzekutoni
veçanërisht Super_Optimizim. Autori nuk mban përgjegjësi për humbje
të dhënash nga përdorimi pa lexuar paralajmërimet.

---

## English

`.bat` scripts for cleaning, optimizing and maintaining Windows 10.
All three scripts were created by **MR ERIONXX** and require Administrator
rights. After running one, do a **Restart** to apply all changes.

> Free to use, only with the author's credit kept. See `LICENSE.md`.
> Removing the author's name or claiming the project as your own is forbidden.

### Structure

```
mirembajtje-windows/
├── README.md
├── LICENSE.md
└── scripts/
    ├── Mirembajtje_Laptopi.bat   # level 1 — the gentlest
    ├── Optimizim_Total.bat       # level 2 — medium
    └── Super_Optimizim.bat       # level 3 — the most aggressive
```

Choose **one** level according to your need. Do not run all three one after
another without a reason, because their steps overlap (Temp cleaning,
Defender scan, etc.).

### Requirements

- Windows 10 (the basic commands also work on Windows 11, but the project
  is designed and named for Windows 10)
- Administrator rights — the script requests them itself if you do not
  start it as Admin
- Internet connection for DISM `/Restorehealth` and for updating
  Windows Defender
- Time: cleaning is quick, but DISM + SFC can take 15–30 minutes and
  the full Defender scan even longer

### 1. Mirembajtje_Laptopi.bat — gentle level, for regular maintenance

This is the script for daily / weekly use, without touching startup,
services or the power plan.

1. **Cleaning unnecessary files** — `%TEMP%`, `C:\Windows\Temp`,
   `Prefetch`, Recycle Bin and leftover Windows Update downloads
   (`SoftwareDistribution\Download`, stopping/restarting the `wuauserv`
   service)
2. **Network optimization** — `ipconfig /flushdns` and `netsh winsock reset`
3. **System check and repair** — `DISM /Online /Cleanup-image /Restorehealth`
   and then `sfc /scannow`
4. **Deep antivirus scan** — Windows Defender signature update
   (`MpCmdRun -SignatureUpdate`) and full scan
   (`MpCmdRun -Scan -ScanType 2`)

Use it when the laptop lags but you do not want to change system settings.

### 2. Optimizim_Total.bat — medium level, for faster boot

It adds startup and power optimization on top of cleaning.
It does **not** do DISM/SFC and it does not do `winsock reset`.

1. **Cleaning** — Temp, `C:\Windows\Temp`, Prefetch, Recycle Bin,
   Windows Update leftovers and `ipconfig /flushdns`
2. **Disabling background apps and services** — blocks Windows background
   apps, stops telemetry services (`DiagTrack`, `dmwappushservice`),
   `MapsBroker` and Xbox services (set to `demand`, not fully disabled)
3. **Startup cleaning** — removes from `Run` (HKCU/HKLM):
   OneDrive, Spotify, Skype, Steam, Discord, Teams, MicrosoftEdgeAutoLaunch,
   iTunesHelper
4. **Ultimate Performance plan** — creates and activates the plan
   `e9a42b02-d5df-448d-aa00-03f14749eb61`
5. **Deep antivirus scan** — as in level 1, Defender full scan

Use it when boot is slow and many programs open by themselves.

### 3. Super_Optimizim.bat — aggressive level, only when needed

This is the most complete and most aggressive combination. Use it rarely,
and only after you have understood the warnings below.

1. **Releasing locked files** — restarts `explorer.exe` to release
   locked files
2. **Deep cleaning** — as in level 1, plus `ipconfig /flushdns`
   and `netsh winsock reset`
3. **Startup and background services** — as in level 2, plus:
   - startup delay is set to 0
   - `Fax` is fully disabled, Xbox services are set to `demand`
   - all `.lnk` shortcuts are also removed from the user's Startup folder
4. **Maximum speed** — Ultimate Performance plan and
   disk optimization `defrag C: /O` (TRIM for SSD / optimization for HDD)
5. **System repair** — DISM `/Restorehealth` + `sfc /scannow`
6. **Deep antivirus scan** — **removes all Windows Defender exclusions**
   before scanning, then signature update and full scan

#### Warnings for Super_Optimizim

- Removing Startup shortcuts means programs you set yourself to open with
  Windows **will no longer open by themselves** — you will open them manually.
- Removing Defender exclusions means folders/programs you deliberately
  excluded **will be scanned again** and may be blocked.
- Disabling `Fax` and `MapsBroker` is safe only if you do not use
  those services.

### 4. pastro-pc.bat — monthly SUPER PREMIUM cleaning

Monthly script (the script itself says "once a month"), different from
the first three: it cleans TEMP/Prefetch, Windows Update cache,
thumbnail cache, CBS logs, Recycle Bin, `DISM /StartComponentCleanup`,
`defrag C: /O`, 5 tweaks (MenuShowDelay 0, StartupDelay 0,
VisualFX "Best performance", SysMain disabled, Storage Sense),
`ipconfig /flushdns` and `sfc /verifyonly`.
**Careful:** `sfc /verifyonly` only verifies, it does not repair; the
antivirus scan at the end is optional and quick (`ScanType 1`), not full.
And unlike the first three, this script **does not request Admin itself**
— it must be started manually with Run as administrator, otherwise it stops.
Full step-by-step guide: `GUIDE.md`.

### Extra tool: bej-zip-kod — ZIP with code only

`tools/bej-zip-kod/` contains `BEJ-ZIP-KOD.bat` + `bej-zip-kod.ps1`
(both together, in the project root folder). It makes a ZIP with only
the code, without `data/`, `node_modules/`, `dist/`, `.git/`, without
`*.mp4`/`*.pyc`/`*.zip`, with output on the Desktop:
`cmimradar-ndryshimet-kod.zip` (the original name for ÇmimRadar,
left as it was). If the ZIP comes out over 24 MB, the script itself
warns not to upload it. Full guide: `GUIDE.md`.

### How to use

1. Download the `scripts/` folder or just the script you need.
2. Right-click the `.bat` → **Run as administrator**
   (if you open it with a double-click, the script requests Admin itself
   and reopens).
3. Wait for it to finish — **do not close the window** during DISM/SFC
   and the Defender scan.
4. Do a **Restart** when the script asks for it at the end.

### What was organized in the public version

Compared with the author's original files, the public version has only
two necessary changes, without touching the logic of the scripts:

- **Super_Optimizim:** the personal section that deleted a specific file
  from the author's `Downloads` folder was removed
  (`C:\Users\<username>\...`).
  The public version is generic, contains no personal path and does not
  delete user files.
- **Optimizim_Total:** the `powercfg` bug was fixed — it used
  `tokens=2`, which does not capture the plan GUID. It is now `tokens=4`,
  as in Super_Optimizim, which is the correct form
  (`Power Scheme GUID: <GUID>` → the 4th token).

The author's originals were not touched; they remain with him.

### Disclaimer

The scripts are provided "as is", without warranty. Running them changes
system settings (startup, services, power plan, Defender exclusions).
Back up important data before running them, especially Super_Optimizim.
The author is not responsible for data loss from use without reading
the warnings.

---

**Krijuar nga / Created by MR ERIONXX — © 2026 All rights reserved.**
