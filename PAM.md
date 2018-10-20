# Liste an Seiten die ich bereits gelesen habe oder noch lesen muss

## Thema: PAM

- ### Allgemeine Seite
  - [ ] https://www.selflinux.org/selflinux/html/grundlagen_sicherheit05.html
  - [ ] https://linuxwiki.de/PAM
  - [ ] https://www.admin-magazin.de/Das-Heft/2009/03/Benutzeranmeldung-mit-Fingerabdruck/(offset)/4
  - [ ] https://www.debian.org/doc/manuals/debian-reference/ch04.de.html
  - [ ] https://www.linux.com/news/understanding-pam

- ### man pages
    - [ ] https://linux.die.net/man/5/pam.d
        - These files list the PAMs that will do the authentication tasks required by this service, and the appropriate behavior of the PAM-API in the event that individual PAMs fail.
            - Welcher Teil der Konfiguration definiert das "angemessene Verhalten"?
        - The syntax of the /etc/pam.conf configuration file is as follows. The file is made up of a list of rules, each rule is typically placed on a single line, but may be extended with an escaped end of line: '\<LF>'. Comments are preceded with '#' marks and extend to the next end of line.
        - #### Regelformat:
            - `service type control module-path module-arguments`<br>
            The syntax of files contained in the /etc/pam.d/ directory, are identical except for the absence of any `service` field. In this case, the service is the name of the file in the /etc/pam.d/ directory. This filename must be in lower case.
                - ~~Aber die config files in /etc/pam.d/, die ich mir bisher angeschaut habe, haben das `service` field in ihren `rules`.~~
                - ~~Beispiel aus /etc/pam.d/su:<br>
                `auth       sufficient pam_wheel.so trust`~~
                - Im obigen Beispiel ist `auth` der `type` und nicht der `service`.
    - [ ] https://linux.die.net/man/8/pam_unix
    - [ ] https://linux.die.net/man/8/pam_keyinit
    - [ ] https://linux.die.net/man/8/pam_loginuid
