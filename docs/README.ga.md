# WindowsOpenBSDdistributor

Íoslódáil stóranna gladiola chuig tiomántán USB ar Windows, agus ansin suiteáil iad ar mheaisín OpenBSD — fiú nuair nach bhfuil rochtain dhíreach ar an Idirlíon ag an gcóras OpenBSD.

Tacaíonn an dá script le **roghnú idirghníomhach** ionas gur féidir leat a roghnú go beacht cé na stóranna atá le híoslódáil nó le suiteáil gach uair.

---

## Céim 1 – Íoslódáil chuig tiomántán USB (Windows)

### Réamhriachtanais

* [Git do Windows](https://git-scm.com/download/win) suiteáilte agus sa `PATH`.
* Tiomántán USB plugáilte isteach (m.sh. tiomántán `E:`).

### Rith an script PowerShell

```powershell
# Ceadaigh scripts áitiúla a rith (uair amháin, rith mar Riarthóir más gá)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mód | Ordú |
|---|---|
| **Idirghníomhach** – fuinneog roghnúcháin GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Stóranna ar leith** – gan GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Gach stóras** – gan GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Le comhartha GitHub (ardaíonn teorainn ráta) | cuir `-Token ghp_yourToken` le haon ordú thuas |

**Mód idirghníomhach** aimsíonn na stóranna gladiola poiblí go léir ón API GitHub agus osclaíonn fuinneog `Out-GridView` ag liostáil ainmneacha na stóranna. Coinnigh **Ctrl** nó **Shift** síos chun stóranna iolracha a roghnú, ansin cliceáil **OK**.

Clonaíonn an script gach stóras roghnaithe isteach in `<LitirTiomántáin>:\gladiola_repos\`. Má clonaíodh stóras cheana féin, déantar é a fháil agus a athshocrú go dtí an `HEAD` is déanaí.

Díchuir an tiomántán USB go sábháilte nuair a thuairisceoidh an script go raibh rath ann.

---

## Céim 2 – Suiteáil ar OpenBSD

### Réamhriachtanais

* Rochtain root (nó `doas`) ar an meaisín OpenBSD.
* An tiomántán USB ceangailte go fisiciúil leis an meaisín OpenBSD.

### Suiteáil an tiomántán USB

```sh
# Aimsigh ainm an ghléis (cuardaigh an tiomántán USB, is minic sd1 nó sd2)
sysctl hw.disknames

# Suiteáil é (cuir sd1i in ionad do dheighilt iarbhír)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Rith an script suiteála

| Mód | Ordú |
|---|---|
| **Idirghníomhach** – roghchlár uimhrithe | `doas sh openbsd/install_repos.sh` |
| **Stóranna ar leith** – gan roghchlár | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Gach stóras** – gan roghchlár | `doas sh openbsd/install_repos.sh -a` |
| Foinse / ceann scríbe saincheaptha | cuir `-s /mnt/usbkey -d /home/myuser/gladiola` leis |

**Mód idirghníomhach** liostaíonn gach stóras a aimsítear i `gladiola_repos/` ar an tiomántán USB le huimhir, ansin iarrann sé ort na huimhreacha atá uait a chur isteach (m.sh. `1 3 5`). Brúigh **Iontráil** gan aon ionchur chun gach rud a shuiteáil.

Do gach stóras roghnaithe, déanann an script:
1. É a chóipeáil chuig `<eolaire_suiteála>/` (réamhshocraithe: `/usr/local/gladiola`)
2. `chmod 755` a shocrú ar na comhaid `.sh` go léir
3. `make install` a rith má tá `Makefile` i láthair (taispeántar aschur ar theip amháin)

### Díshuiteáil an tiomántán USB nuair atá tú críochnaithe

```sh
doas umount /mnt/usb
```

---

## Leagan amach eolaire

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Rith ar Windows chun an tiomántán USB a líonadh
├── openbsd/
│   └── install_repos.sh     # Rith ar OpenBSD chun suiteáil ón tiomántán USB
└── README.md
```
