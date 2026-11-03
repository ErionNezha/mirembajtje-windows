# Udhëzues | Guide — pastro-pc.bat dhe bej-zip-kod

<!-- Created by Erion Nezha — © 2026 All rights reserved -->

[Shqip](#shqip) | [English](#english)

> Ky udhëzues është shkruar vetëm nga ajo që bëjnë realisht skriptet,
> e verifikuar rresht për rresht nga kodi. Asnjë hap i përshkruar këtu
> nuk është supozuar.
> This guide describes only what the scripts actually do, verified
> line by line from the code. No step described here was assumed.

---

## Shqip

### 1. pastro-pc.bat — për çfarë përdoret?

**Përdorimi:** pastrim mujor dhe përshpejtim i PC-së me Windows.
Vetë skripti thotë në krye: "Përdore 1 herë në muaj."
Është një skript mirëmbajtjeje, i ndryshëm nga tre të parët e repo-s:
ai nuk bën skanim të plotë Defender dhe nuk riparon file-t e sistemit
— ai vetëm i **verifikon** ato.

**Kush duhet ta përdorë:** kushdo që do një pastrim mujor të plotë
+ 5 tweaks shpejtësie, pa ndryshuar planin e energjisë dhe pa prekur
startup-in me heqje programesh (ky skript nuk heq programe nga `Run`).

**Kërkesat — ndryshim i rëndësishëm nga tre skriptet e tjerë:**
- Duhet nisur **manualisht si Administrator**: kliko me të djathtën →
  **Run as administrator**.
- Ndryshe nga Mirembajtje / Optimizim_Total / Super_Optimizim, ky skript
  **nuk e kërkon vetë Adminin** — nëse nuk je Admin, ai ndalon me
  mesazhin "KERKOHET Run as administrator" dhe del.
- Pas përfundimit: **Restart**, që tweaks të hyjnë në fuqi.

#### Çfarë bën, hap pas hapi (9 hapa, të verifikuar nga kodi)

Para dhe pas pastrimit, skripti tregon hapësirën e lirë në `C:`
(`wmic logicaldisk ... FreeSpace`), që ta krahasosh vetë.

1. **Pastrim TEMP + Prefetch** — fshin përmbajtjen e `%TEMP%`,
   `C:\Windows\Temp` dhe `C:\Windows\Prefetch`.
   (Ndryshe nga tre të parët, ai nuk e fshin dhe rikrijon vetë dosjen
   `%TEMP%`, vetëm përmbajtjen e saj.)
2. **Cache i Windows Update** — ndalon `wuauserv`, fshin
   `C:\Windows\SoftwareDistribution\Download\*`, rinis `wuauserv`.
3. **Thumbnail cache + log-e** — fshin `thumbcache_*.db` dhe
   `C:\Windows\Logs\CBS\*.log`.
4. **Recycle Bin** — e zbraz me `rd /s /q "C:\$Recycle.Bin"`.
5. **Pastrim komponentesh të vjetër Windows** —
   `DISM /Online /Cleanup-Image /StartComponentCleanup`.
   Kjo **nuk** është riparim (`/Restorehealth`): ajo heq komponentë
   të vjetër, nuk riparon file të dëmtuar.
6. **Optimizim disku** — `defrag C: /O` (TRIM për SSD / optimizim për HDD).
7. **5 tweaks shpejtësie** (të gjitha me `reg add` / `sc config`):
   - `MenuShowDelay = 0` — menytë hapen menjëherë
   - `StartupDelayInMSec = 0` — hiqet vonesa e programeve në ndezje
   - `VisualFXSetting = 2` — efektet vizuale në "Best performance"
   - `SysMain` vendoset `start=disabled` — vini re: skripti **nuk e
     ndalon** shërbimin që po punon, vetëm e çaktivizon për nisjet
     e ardhshme; efekti i plotë vjen pas Restart-it
   - `Storage Sense` aktivizohet (`StoragePolicy` vlera `01 = 1`)
8. **Pastrim DNS** — `ipconfig /flushdns`.
   (Nuk bën `netsh winsock reset`, ndryshe nga Mirembajtje dhe Super.)
9. **Verifikim file-sh sistemi** — `sfc /verifyonly`.
   **Kujdes:** kjo vetëm **verifikon**, nuk riparon. Nëse do riparim,
   përdor Mirembajtje_Laptopi ose Super_Optimizim, që bëjnë
   `DISM /Restorehealth` + `sfc /scannow`.

#### Skanimi antivirus — opsional, jo i plotë

Në fund, skripti pyet: "Don skanim të shpejtë antivirus tani? (Y/N)"
- Nëse përgjigjesh `Y`, nis **skanim i shpejtë** Defender
  (`MpCmdRun -Scan -ScanType 1`) — jo skanim i plotë (`ScanType 2`
  si te tre skriptet e tjerë).
- Nëse e nis me argumentin `/auto` (`pastro-pc.bat /auto`), pyetja
  kapërcehet, skripti nuk bën pause në fund, por del direkt.

#### Çfarë NUK bën pastro-pc.bat

- Nuk heq programe nga startup-i (`Run`).
- Nuk ndryshon planin e energjisë (pa Ultimate Performance).
- Nuk riparon file-t e sistemit (vetëm `/verifyonly`).
- Nuk heq përjashtimet e Defender-it (si Super_Optimizim).
- Nuk bën `winsock reset`.

### 2. bej-zip-kod — për çfarë përdoret?

**Përdorimi:** të bësh një ZIP **vetëm me kodin** e një projekti,
pa të dhëna, pa video dhe pa file të rëndë — që ta dërgosh diku
(p.sh. në chat) pa kaluar kufirin e ngarkimit.

Ky mjet u krijua fillimisht për **ÇmimRadar** — prandaj file-i dalës
quhet ende `cmimradar-ndryshimet-kod.zip`, edhe nëse e përdor për
një projekt tjetër. Komanda është lënë fiks siç ishte; emri nuk
u ndryshua që të mos prishet rrjedha origjinale.

**Dy file-t duhet të jenë bashkë, në të njëjtën dosje:**
- `tools/bej-zip-kod/BEJ-ZIP-KOD.bat` — nisësi: thërret PowerShell-in
  me `powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bej-zip-kod.ps1"`
  dhe pastaj bën `pause`.
- `tools/bej-zip-kod/bej-zip-kod.ps1` — logjika e vërtetë.

#### Si përdoret, hap pas hapi

1. Kopjo **të dy** file-t në **dosjen rrënjë të projektit** që do
   të zip-osh (jo në një dosje bosh, jo në Desktop).
2. Nis `BEJ-ZIP-KOD.bat` me dopio-klik (nuk kërkon Administrator).
3. Skripti kopjon file-t në një dosje të përkohshme në `%TEMP%`
   (`cmimradar-kod-staging`), pastaj i ngjesh me
   `Compress-Archive -CompressionLevel Optimal`.
4. Rezultati del në **Desktop**: `cmimradar-ndryshimet-kod.zip`.
5. Në fund shfaq: numrin e file-ve të përfshirë dhe madhësinë në MB.
   - Nëse është **mbi 24 MB**, skripti paralajmëron vetë:
     "KUJDES: ende mbi 24 MB - dergo kete numer si mesazh, mos e ngarko."
   - Nëse është **24 MB ose më pak**, thotë: "Ngarkoje kete ZIP ne chat."

#### Çfarë përjashtohet (të verifikuara nga kodi)

Dosje të plota që hidhen:
`node_modules`, `__pycache__`, `dist`, `test-shots`, `work`, `data`, `.git`

File që hidhen:
`*.mp4`, `*.pyc`, `*.zip` — plus vetë mjeti
(`bej-zip-kod.ps1` dhe `BEJ-ZIP-KOD.bat` nuk futen në ZIP).

**Kujdes:** çdo dosje që quhet `work` ose `data` brenda projektit
përjashtohet plotësisht, edhe nëse përmban kod. Nëse projekti yt
ka kod të rëndësishëm në një dosje `work/` ose `data/`, zhvendose
para se ta nisësh, ose prano që nuk do të jetë në ZIP.

#### Gabimi më i shpeshtë — dosja bosh

Nëse i vendos të dy file-t në një dosje bosh dhe i nis, ZIP-i del
me 1 file / 0 MB — sepse nuk ka kod për të zip-uar aty.
Zgjidhja: vendosi **brenda dosjes së projektit** (aty ku është kodi),
pastaj nise sërish. Kjo është verifikuar në përdorim real:
vendosja e gabuar dha 1 file / 0 MB, vendosja brenda projektit dha
150 file / 6.61 MB për ÇmimRadar.

#### Çfarë NUK bën bej-zip-kod

- Nuk fshin dhe nuk ndryshon kodin origjinal — vetëm e **kopjon**
  në staging, pastaj e fshin staging-un.
- Nuk ngarkon asgjë vetë në internet — vetëm krijon ZIP-in në Desktop.
  Ngarkimi bëhet manualisht nga ti.
- Nuk kërkon Administrator dhe nuk ndryshon cilësime sistemi.

---

## English

### 1. pastro-pc.bat — what is it for?

**Use:** monthly PC cleaning and speed-up for Windows.
The script itself says at the top: "Use once a month."
It is a maintenance script, different from the first three in the repo:
it does not do a full Defender scan and it does not repair system
files — it only **verifies** them.

**Who should use it:** anyone who wants a complete monthly clean
+ 5 speed tweaks, without changing the power plan and without
removing programs from startup (this script does not remove programs
from `Run`).

**Requirements — important difference from the other three scripts:**
- It must be started **manually as Administrator**: right-click →
  **Run as administrator**.
- Unlike Mirembajtje / Optimizim_Total / Super_Optimizim, this script
  **does not request Admin itself** — if you are not Admin, it stops
  with the message "KERKOHET Run as administrator" and exits.
- After it finishes: **Restart**, so the tweaks take effect.

#### What it does, step by step (9 steps, verified from the code)

Before and after cleaning, the script shows free space on `C:`
(`wmic logicaldisk ... FreeSpace`), so you can compare yourself.

1. **TEMP + Prefetch cleaning** — deletes the contents of `%TEMP%`,
   `C:\Windows\Temp` and `C:\Windows\Prefetch`.
   (Unlike the first three, it does not delete and recreate the
   `%TEMP%` folder itself, only its contents.)
2. **Windows Update cache** — stops `wuauserv`, deletes
   `C:\Windows\SoftwareDistribution\Download\*`, restarts `wuauserv`.
3. **Thumbnail cache + logs** — deletes `thumbcache_*.db` and
   `C:\Windows\Logs\CBS\*.log`.
4. **Recycle Bin** — emptied with `rd /s /q "C:\$Recycle.Bin"`.
5. **Old Windows components cleanup** —
   `DISM /Online /Cleanup-Image /StartComponentCleanup`.
   This is **not** a repair (`/Restorehealth`): it removes old
   components, it does not repair damaged files.
6. **Disk optimization** — `defrag C: /O` (TRIM for SSD / optimization
   for HDD).
7. **5 speed tweaks** (all with `reg add` / `sc config`):
   - `MenuShowDelay = 0` — menus open immediately
   - `StartupDelayInMSec = 0` — removes the startup program delay
   - `VisualFXSetting = 2` — visual effects on "Best performance"
   - `SysMain` set to `start=disabled` — note: the script does **not
     stop** the currently running service, it only disables it for
     future starts; the full effect comes after a Restart
   - `Storage Sense` enabled (`StoragePolicy` value `01 = 1`)
8. **DNS cleaning** — `ipconfig /flushdns`.
   (It does not do `netsh winsock reset`, unlike Mirembajtje and Super.)
9. **System file verification** — `sfc /verifyonly`.
   **Careful:** this only **verifies**, it does not repair. If you want
   a repair, use Mirembajtje_Laptopi or Super_Optimizim, which do
   `DISM /Restorehealth` + `sfc /scannow`.

#### Antivirus scan — optional, not full

At the end, the script asks: "Don skanim të shpejtë antivirus tani? (Y/N)"
- If you answer `Y`, it starts a **quick** Defender scan
  (`MpCmdRun -Scan -ScanType 1`) — not a full scan (`ScanType 2`
  as in the other three scripts).
- If you start it with the argument `/auto` (`pastro-pc.bat /auto`),
  the question is skipped, the script does not pause at the end,
  but exits directly.

#### What pastro-pc.bat does NOT do

- It does not remove programs from startup (`Run`).
- It does not change the power plan (no Ultimate Performance).
- It does not repair system files (only `/verifyonly`).
- It does not remove Defender exclusions (as Super_Optimizim does).
- It does not do `winsock reset`.

### 2. bej-zip-kod — what is it for?

**Use:** to make a ZIP with **only the code** of a project,
without data, without videos and without heavy files — so you can
send it somewhere (e.g. in a chat) without exceeding the upload limit.

This tool was originally created for **ÇmimRadar** — that is why the
output file is still called `cmimradar-ndryshimet-kod.zip`, even if
you use it for another project. The command was left exactly as it
was; the name was not changed, so the original workflow is not broken.

**Both files must be together, in the same folder:**
- `tools/bej-zip-kod/BEJ-ZIP-KOD.bat` — the launcher: calls PowerShell
  with `powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bej-zip-kod.ps1"`
  and then does `pause`.
- `tools/bej-zip-kod/bej-zip-kod.ps1` — the real logic.

#### How to use it, step by step

1. Copy **both** files into the **root folder of the project** you
   want to zip (not into an empty folder, not onto the Desktop).
2. Start `BEJ-ZIP-KOD.bat` with a double-click (it does not require
   Administrator).
3. The script copies the files into a temporary folder in `%TEMP%`
   (`cmimradar-kod-staging`), then compresses them with
   `Compress-Archive -CompressionLevel Optimal`.
4. The result appears on the **Desktop**:
   `cmimradar-ndryshimet-kod.zip`.
5. At the end it shows: the number of files included and the size in MB.
   - If it is **over 24 MB**, the script itself warns:
     "KUJDES: ende mbi 24 MB - dergo kete numer si mesazh, mos e ngarko."
   - If it is **24 MB or less**, it says: "Ngarkoje kete ZIP ne chat."

#### What is excluded (verified from the code)

Whole folders that are skipped:
`node_modules`, `__pycache__`, `dist`, `test-shots`, `work`, `data`, `.git`

Files that are skipped:
`*.mp4`, `*.pyc`, `*.zip` — plus the tool itself
(`bej-zip-kod.ps1` and `BEJ-ZIP-KOD.bat` are not put in the ZIP).

**Careful:** any folder called `work` or `data` inside the project
is excluded completely, even if it contains code. If your project
has important code in a `work/` or `data/` folder, move it before
starting, or accept that it will not be in the ZIP.

#### The most common mistake — an empty folder

If you put both files in an empty folder and start them, the ZIP
comes out with 1 file / 0 MB — because there is no code to zip there.
Fix: put them **inside the project folder** (where the code is),
then start again. This was verified in real use:
the wrong placement gave 1 file / 0 MB, placement inside the project
gave 150 files / 6.61 MB for ÇmimRadar.

#### What bej-zip-kod does NOT do

- It does not delete or change the original code — it only **copies**
  it to staging, then deletes the staging folder.
- It does not upload anything itself to the internet — it only
  creates the ZIP on the Desktop. Uploading is done manually by you.
- It does not require Administrator and does not change system settings.

---

**Krijuar nga / Created by MR ERIONXX — © 2026 All rights reserved.**
