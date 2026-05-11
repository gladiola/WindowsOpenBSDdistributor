# WindowsOpenBSDdistributor

Κατεβάστε τα αποθετήρια gladiola σε USB από τα Windows και εγκαταστήστε τα σε μηχάνημα OpenBSD, ακόμη και όταν το OpenBSD δεν έχει άμεση πρόσβαση στο διαδίκτυο.

Και τα δύο scripts υποστηρίζουν **διαδραστική επιλογή**, ώστε να διαλέγετε ακριβώς ποια αποθετήρια θα κατεβάσετε ή θα εγκαταστήσετε κάθε φορά.

---

## Βήμα 1 – Λήψη σε USB (Windows)

### Προαπαιτούμενα

* Εγκατεστημένο [Git for Windows](https://git-scm.com/download/win) και διαθέσιμο στο `PATH`.
* Συνδεδεμένη μονάδα USB (π.χ. `E:`).

### Εκτελέστε το PowerShell script

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Λειτουργία | Εντολή |
|---|---|
| **Διαδραστική** – επιλογή GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Συγκεκριμένα repos** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Όλα τα repos** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

---

## Βήμα 2 – Εγκατάσταση στο OpenBSD

### Προαπαιτούμενα

* Πρόσβαση root ή `doas` στο OpenBSD.
* Η μονάδα USB συνδεδεμένη στο OpenBSD.

### Κάντε mount τη μονάδα USB

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Εκτελέστε το script εγκατάστασης

```sh
doas sh openbsd/install_repos.sh
```

### Κάντε unmount όταν τελειώσετε

```sh
doas umount /mnt/usb
```
