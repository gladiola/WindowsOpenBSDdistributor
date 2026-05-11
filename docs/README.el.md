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

| Με token GitHub (υψηλότερο όριο αιτήσεων) | πρόσθεσε `-Token ghp_yourToken` σε οποιαδήποτε εντολή παραπάνω |

**Διαδραστική λειτουργία** ανακτά όλα τα δημόσια repos του gladiola από το GitHub API και ανοίγει παράθυρο `Out-GridView` με τα ονόματα των repo. Κράτησε πατημένο **Ctrl** ή **Shift** για πολλαπλή επιλογή και μετά πάτησε **OK**.

Το script κάνει clone κάθε επιλεγμένου repo στο `<DriveLetter>:\\gladiola_repos\\`. Αν ένα repo είχε ήδη κλωνοποιηθεί, κάνει fetch και επαναφέρει στο πιο πρόσφατο `HEAD`.

Κάνε ασφαλή εξαγωγή του USB όταν το script αναφέρει επιτυχία.

---

## Βήμα 2 – Εγκατάσταση στο OpenBSD

### Προαπαιτούμενα

* Πρόσβαση root ή `doas` στο OpenBSD.
* Η μονάδα USB συνδεδεμένη στο OpenBSD.

### Κάντε mount τη μονάδα USB

```sh
# Βρες το όνομα της συσκευής (αναζήτησε το USB, συνήθως sd1 ή sd2)
sysctl hw.disknames

# Κάνε mount (αντικατάστησε το sd1i με το πραγματικό partition σου)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Εκτελέστε το script εγκατάστασης

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Διαδραστική λειτουργία** εμφανίζει κάθε repo που βρίσκεται στο `gladiola_repos/` του USB με αριθμό και σε προτρέπει να εισαγάγεις τους αριθμούς που θέλεις (π.χ. `1 3 5`). Πάτησε **Enter** χωρίς εισαγωγή για εγκατάσταση όλων.

Για κάθε επιλεγμένο repository το script:
1. Το αντιγράφει στο `<install_dir>/` (προεπιλογή `/usr/local/gladiola`)
2. Ορίζει `chmod 755` σε όλα τα αρχεία `.sh`
3. Εκτελεί `make install` αν υπάρχει `Makefile` (έξοδος εμφανίζεται μόνο σε αποτυχία)

### Κάντε unmount όταν τελειώσετε

```sh
doas umount /mnt/usb
```
