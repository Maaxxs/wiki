# Taskwarrior

Setup of [Taskwarrior](https://taskwarrior.org/).

The taskserver will run on NixOS and we add the config to sync a client
on a computer  and on the [iPhone with the "task add"
app](https://apps.apple.com/de/ app/task-add/id1553253179).

## Enable Taskserver on NixOS

Add the following to your `/etc/nixos/configuration.nix`.

```nixos
  networking.firewall = {
    allowedTCPPorts = [ 53589 ];
  };

  services.taskserver.enable = true;
  services.taskserver.fqdn = "your-server.com";
  services.taskserver.listenHost = "::";
  services.taskserver.organisations.personal.users = [ "bob" ];
```

This will

- open the required TCP port in the firewall
- enable the taskserver
- create an organization called `personal` with the user `bob`

Activate the configuration.

```sh
nixos-rebuild switch
```

## Export the Configuration and Setup a Client

Export the configuration for the user `bob`. You either run on the
server

```sh
nixos-taskserver user export personal bob > bob_config.sh
```

and copy the `bob_config.sh` file to you computer. Assuming you've got
ssh enabled and the hostname of the server is `nixos` you can just run

```sh
ssh nixos nixos-taskserver user export personal bob > bob_config.sh
```

This exports a shell script that will add the required certificates to
your local task configuration when you run it.

```sh
sh bob_config.sh
```

Now you can run the initial sync with your taskserver (you need the
`task` software, of course. You should be able to find that in your
package
repository).

```sh
task init sync
# all subsequent syncs with
task sync
```

If you get the error `Taskserver not configured`, it's likely due to the
missing configuration option `taskd.server` in your `~/.taskrc` that is
not added with the script. If you set it accordingly, it should
just work.

```
taskd.server=your-server.com:53589
```

## Mobile Configuration on an iPhone

I use [this app that lets you add tasks on your iPhone when I'm on the
go](https://apps.apple.com/de/app/task-add/id1553253179) and I can later
check on my computer what I need to do.

The app requires

- a taskrc
- the CA cert
- the private key of your user
- the server cert

Your can find the keys in `~/.task/keys/`. Copy these files to your
iPhone, for example use the  "Notes to Yourself" in Signal or whatever
you like.

```
~ | tree .task/keys
.task/keys
├── ca.cert
├── private.key
└── public.cert
```

You can either copy the "original" `~/.taskrc` file or just create a
minimal version of it by taking the following two required options from
the configuration.

```
taskd.server=your-server.com:53589
taskd.credentials=personal/bob/some-long-UUID
```

On the iPhone open the app, select a profile, select *Configure
Taskserver*:

- Tap on *Select TASKRC* and choose your `taskrc` file
- `taskd.certificate` select the `public.cert`
- `taskd.key` select your `private.key`
- `taskd.ca` select the `ca.cert`

Then tap the button in the top right corner to test the connection.

You'll probably get a `BadCertificateException` error that displays the
SHA1 fingerprint of the certificate. You can tap *Trust* **if that
fingerprint matches the fingerprint on your NixOS server that you can
generate with the following command**:

```sh
nix-shell -p openssl
openssl x509 -noout -fingerprint -sha1 -inform pem -in /var/lib/taskserver/keys/server.cert
```

That's it. You can now add tasks in the app and sync them to the server
by hitting that circle arrow at the top. On your computer run
`task sync` to sync the latest changes.


## Foreground on Android

Install
[Foreground](https://f-droid.org/en/packages/me.bgregos.brighttask/)
from F-Droid.

Use the `server.cert` as CA certificate. Otherwise you'll get trust
anchor issues. This file is on the taskwarrior server, perhaps at
`/var/lib/taskserver/keys/server.cert`.

```txt
CA Certificate: server.cert
private key file: private.key
private certificate: public.cert    # yes. no mistake.
```

You should know the other information or just look it up in your local
`~/.taskrc`.
