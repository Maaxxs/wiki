# GPG

## Export keys on old machine

Export all public keys.

```sh
gpg -a --export > pubkeys.asc
```

Export all private keys with corresponding public keys.

```sh
gpg -a --export-secret-keys > seckeys.asc
```

Optionally, export trust database of gpg.

```sh
gpg --export-ownertrust > otrust.txt
```

## Import keys on new machine

Transfer these files to the new computer and import them.

```sh
gpg --import pubkeys.asc
gpg --import seckeys.asc
```

Verify (list) the imported public keys with `gpg -k` and the imported
private keys with `gpg -K`.

Optionally, import the trust database.

```sh
gpg --import-ownertrust otrust.txt
```

## No Password Dialog with Thunderbird

I'm not sure anymore if I had this problem only with Gnome or i3 as well.
Currently, with [sway](https://swaywm.org/) everything works out of the box.

With Gnome put the following in `~/.gnupg/gpg-agent.conf` so that thunderbird
actually uses a graphical prompt to display the request for the password of the
key. Otherwise thunderbird fails silently.

```
pinentry-program /usr/bin/pinentry-gnome3
```

## Thunderbird with external GPG keys

Why? Because I don't like to manage two different gpg stores. If I make changes
via the gpg command line tool, they should show up in thunderbird immediately.
And have you heard of the *Primary password feature* in Thunderbird? If you
give Thunderbird your private key, you should definitely use that feature.

[Quoting from the FAQ](https://support.mozilla.org/en-US/kb/openpgp-thunderbird-howto-and-faq#w_how-is-my-personal-key-protected):

> At the time you import your personal key into Thunderbird, we unlock it, and
> protect it with a different password, that is automatically (randomly)
> created. The same automatic password will be used for all OpenPGP secret keys
> managed by Thunderbird. You should use the Thunderbird feature to set a
> Primary Password. Without a Primary Password, your OpenPGP keys in your
> profile directory are unprotected.

Open the config editor in Thunderbird and allow the external use of gpg and
change the path to whatever `which gpg` evaluates to.

```
mail.openpgp.allow_external_gnupg -> TRUE
mail.openpgp.alternative_gpg_path -> /usr/bin/gpg
```

- Go the the account settings of the mail account, select the _End-To-End
  Encryption_ tab and press the _Add Key_ button.
- Then select _Use your external key through GnuGPG_.
- Copy and paste your key ID into the field (in a terminal you can use `gpg
  --list-secret-keys` to find your key ID)

Then open the _OpenPGP Key Manager_ and import your own public key (e.g.
File &rarr; Import public key) and set it to *Accepted* in the import prompt (you can
export your public key via `gpg --export --armor --output public.asc <keyid>`).

Lastly, restart Thunderbird.

## Storage and backup

Optional: Make archive of folder

```sh
tar czf gpg-backup.tgz gpg-backup
```

Encrypt it symmetrically with gpg

```sh
gpg -o gpg-backup.tgz.gpg --symmetric gpg-backup.tgz
```

This can be decrypted by running the following command and entering the password
used for the symmetric encryption.

```sh
gpg gpg-backup.tgz.gpg
```

## Keys

Meaning of shortcuts:

```
sec => 'SECret key'
ssb => 'Secret SuBkey'
pub => 'PUBlic key'
sub => 'public SUBkey'
```
