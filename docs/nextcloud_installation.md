# Nextcloud Installation on Ubuntu 21.04.4 LTS

Docs: <https://docs.nextcloud.com/server/stable/admin_manual/installation/example_ubuntu.html>

```sh
sudo apt update
sudo apt install apache2 mariadb-server libapache2-mod-php7.4
sudo apt install php7.4-gd php7.4-mysql php7.4-curl php7.4-mbstring php7.4-intl
sudo apt install php7.4-gmp php7.4-bcmath php-imagick php7.4-xml php7.4-zip
```

Change MySQL root password.

**Note: Instead of using the method below, just run
`mysql_secure_installation`. This will prompt you to change the `root` password
as well and you should/must(!) absolutely run this command anyway.**

Connect to db with default root password `root`.
```sh
sudo mysql -u root -p
```

Then change it:
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'NEW_SECURE_PASSWORD';
FLUSH PRIVILEGES;
```

MySQL socket: `/run/mysqld/mysqld.sock`

Useful commands after logging into DB
```sql
SELECT User,Host from mysql.user;
show databases;
use nextcloud; show tables;
```

For backups with `mysqldump` the parameter `--default-character-set=utf8mb4`
must be used because the database uses `utf8mb4`. Otherwise, the backup seems
broken when being restored.


*NOT NEEDED*. Nextcloud will create the user and database itself.

Create Nextcloud user (change `nextcloud_dbuser` and `password`):
```sql
CREATE USER 'nextcloud_dbuser'@'localhost' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud_dbuser'@'localhost';
FLUSH PRIVILEGES;
quit;
```
*END NOT NEEDED*

Download current nextlcoud release from <https://nextcloud.com/install>

Check signature
```sh
wget https://download.nextcloud.com/server/releases/nextcloud-x.y.z.tar.bz2.asc
wget https://nextcloud.com/nextcloud.asc
gpg --import nextcloud.asc
gpg --verify nextcloud-x.y.z.tar.bz2.asc nextcloud-x.y.z.tar.bz2
```

Unzip/untar it and copy it to the document root if Apache2 is used.
```sh
unzip nextcloud-x.y.z.zip
sudo cp -r nextcloud /var/www/
```


Generate Apache2 config file: `/etc/apache2/sites-available/nextcloud.conf`:
```conf
<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/
  ServerName  server.name.de

  <Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

     <IfModule mod_dav.c>
       Dav off
     </IfModule>
   </Directory>
</VirtualHost>
```

Enable the configuration:
```sh
a2ensite nextcloud.conf
```

Additional Apache2 configurations:
```sh
# enable module mod_rewrite
a2enmod rewrite

# recommended:
a2enmod headers env dir mime

# restart apache2
systemctl restart apache2
```

## Apache2 enable SSL

Enable ssl with apache2.
```sh
a2enmod ssl
systemctl restart apache2
```

Install `certbot`:
```sh
sudo apt install certbot python3-certbot-apache
```

Get certificate and make sure that the domain is the same domain as specified
in the apache2 configuration as `ServerName`.

```sh
certbot --apache -d server.name.de
```

This will also add a corresponding apache `nextcloud-le-ssl.conf` file. Add the
HSTS header and a custom error and custom log file for nextcloud.

```conf
<IfModule mod_ssl.c>
<VirtualHost *:443>
  DocumentRoot /var/www/nextcloud/
  ServerName  server.name.de

  <IfModule mod_headers.c>
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
    # optionally with ;preload
    # Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
  </IfModule>

  ErrorLog ${APACHE_LOG_DIR}/nextcloud_error.log
  # "combined" also logs the USER_AGENT and the REFERER
  CustomLog ${APACHE_LOG_DIR}/nextcloud_access.log combined
...
```

TODO:
Add logrotate config for this log file?

In `/etc/apache2/conf-available/security.conf` switch off Apache version
disclosure (`ServerTokens`) and do not include information in server-generated
pages (`ServerSignature`).

```apache
ServerTokens Prod
ServerSignature Off
```

## Nextclour setup

Change the owner and group to `www-data` of the `/var/www/nextcloud` directory.
```sh
sudo chown -R www-data:www-data /var/www/nextcloud/
```

Finish the Nextcloud setup.
The db user must be `root` or some other user who is allowed to create users
and assign privileges. The `--admin-user` and `--admin-pass` are the
credentials for the new nextcloud admin user who is allowed to install apps and
so on.

```sh
cd /var/www/nextcloud/
sudo -u www-data php occ maintenance:install --database "mysql" --database-name "nextcloud" --database-user "root" --database-pass 'root-user-password' --admin-user "nextcloud_adminuser" --admin-pass "nextcloud_adminuser_pw"
```


## Nextcloud Settings

### Config.php

#### Misc settings

Set default phone region in `/var/www/nextcloud/config/config.php`.

```php
'default_phone_region' => 'DE',
```

Better user experience (only used if an invalid value is supplied by the user, otherwise, the user's value is used).
```php
'default_language' => 'de',
'default_locale' => 'de_DE',
```

Disable the "Help" item in the user menu (top right corner)
```php
'knowledgebaseenabled' => false,
```

[Delete files in trash automatically](https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/config_sample_php_parameters.html#deleted-items-trash-bin) after 30 days. If space is needed, delete files automatically, too.
```php
'trashbin_retention_obligation' => 'auto, 30',
```

```php
# check that apps only use public and no private APIs of Nextcloud.
'appcodechecker' => true,
'logtimezone' => 'Europe/Berlin',
# https://docs.nextcloud.com/server/stable/admin_manual/configuration_files/file_versioning.html
#'versions_retention_obligation' => 'auto',
```

This disables image previews in nextcloud directories. This feature seems to be
problematic sometimes (check
[CVE-2022-24741](https://www.cvedetails.com/cve/CVE-2022-24741/) and
[CVE-2021-32802](https://www.cvedetails.com/cve/CVE-2021-32802/)).

```php
'enable_previews' => false,
```


#### MariaDB Unix Socket Connection

Use the Unix socket for the MySQL connection.

```php
'dbhost' => 'localhost:/run/mysqld/mysqld.sock',
```

By default, MariaDB only listens on the Unix socket and localhost, which is
specified by the `bind-address`. If this were commented, then MariaDB would
listen on all interfaces. In `/etc/mysql/mariadb.conf.d/50-server.cnf` set the
`skip-networking` option to prevent MariaDB from binding to a network
interface.

```
[mysqld]
...
bind-address      = 127.0.0.1
skip-networking
```

Then restart with `systemctl restart mariadb`.

#### Pretty URLs

Add the following for a virtualhost configuration to make URLs pretty (if
installed in subdirectory, check
[here](https://docs.nextcloud.com/server/stable/admin_manual/installation/source_installation.html#pretty-urls).

```php
'overwrite.cli.url' => 'https://server.name.de',
'htaccess.RewriteBase' => '/',
```

Then regenerate the `.htaccess` file.
```sh
sudo -u www-data php /var/www/nextcloud/occ maintenance:update:htaccess
```

### Nextcloud Cronjob for Regular Tasks

Use the `cron` feature of the OS.

```sh
# get the absolute path of `php`
which php
/usr/bin/php

# edit cron for www-data user
crontab -u www-data -e
```

Append the following job:
```
*/5  *  *  *  * /usr/bin/php -f /var/www/nextcloud/cron.php
```

### Nextcloud Apps

Disable apps

- Activity?
- Circles
- Dashboard
- usage survey
- weather status
- user status

Check if the following apps are installed and wanted.

- Calendar
- Contacts
- 2FA
- Brute force limit


## PHP Settings

Increase the memory limit to the recommended size in `/etc/php/7.4/apache2/php.ini`.
```
memory_limit = 512M
```

In the same file increase the maximum file size for uploads and the maximum
size of POST data.

```php
post_max_size = 10G
upload_max_filesize = 10G
```

The following values can be set as well to increase the timeout.
```php
max_input_time 3600
max_execution_time 3600
```

To get SVG support for the PHP module `imagick`, install
`libmagickcore-6.q16-6-extra`:

```sh
sudo apt install libmagickcore-6.q16-6-extra
```


## Memory Caching

Install the required packages for `redis`

```sh
sudo apt install redis-server php-redis
```

Configure redis in `/etc/redis/redis.conf`
```
# do not listen on a tcp socket (value 0)
port 0
# enable unix socket
unixsocket /run/redis/redis-server.sock
# enable password authentication
requirepass LONG_AND_SECURE_PASSWORD
```

Add the web user `www-data` to the redis group that it can write to the unix
socket.

```sh
usermod -aG redis www-data
```

Then restart the redis server and the apache2 service.
```sh
sudo systemctl restart redis
sudo systemctl restart apache2
```


Edit the `/var/www/nextcloud/config/config.php`

```php
'memcache.local' => '\\OC\\Memcache\\Redis',
// If `memcache.distributed` is not set, it defaults to `memcache.local`
'memcache.locking' => '\\OC\\Memcache\\Redis',
'redis' => [
     'host'     => '/run/redis/redis-server.sock',
     'port'     => 0,
     //'dbindex'  => 0,
     'password' => 'LONG_AND_SECURE_PASSWORD',
     //'timeout'  => 1.5,
],
```

Go the `<your_cloud>.de/settings/admin/overview` and check if everyting worked
and the warning about the memory cache is gone.

## Security

See [Nextcloud CVE list](https://www.cvedetails.com/vulnerability-list/vendor_id-15913/Nextcloud.html)

See [Hardening Guide](https://docs.nextcloud.com/server/stable/admin_manual/installation/harden_server.html)

Setup [Fail2ban for Nextcloud](https://docs.nextcloud.com/server/stable/admin_manual/installation/harden_server.html#setup-a-filter-and-a-jail-for-nextcloud)
```sh
sudo apt install fail2ban
```

Create a filter in `/etc/fail2ban/filter.d/nextcloud.conf`.
```
[Definition]
_groupsre = (?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)
failregex = ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Login failed:
            ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Trusted domain error.
datepattern = ,?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"
```

Create the corresponding jail in `/etc/fail2ban/jail.d/nextcloud.local`.
```
[nextcloud]
backend = auto
enabled = true
port = 80,443
protocol = tcp
filter = nextcloud
maxretry = 10
bantime = 604800
findtime = 43200
logpath = /var/www/nextcloud/data/nextcloud.log
```

Findtime is 12h (43200) with 10 matches (tries) and bantime is 1 week (604800).

TODO: test the jail

Activate other jails such as botsearch, mail crawler, 404 scanner, ssh jail.


## Email setup


```sh
sudo apt install sendmail
```

While this installs, you might see this:

```log
Everything you need to support STARTTLS (encrypted mail transmission
and user authentication via certificates) is installed and configured
but is *NOT* being used.

To enable sendmail to use STARTTLS, you need to:
1) Add this line to /etc/mail/sendmail.mc and optionally
   to /etc/mail/submit.mc:
     include(`/etc/mail/tls/starttls.m4')dnl
     2) Run sendmailconfig
     3) Restart sendmail
```

Then add `include(``/etc/mail/tls/starttls.m4')dnl` to both files,
`/etc/mail/sendmail.mc` and `/etc/mail/submit.mc` and run `sendmailconfig` to
reconfigure the mail service.

Finally, configure `sendmail` in the `/var/www/nextcloud/config/config.php`:

```php
'mail_smtpmode' => 'sendmail',
'mail_smtphost' => '127.0.0.1',
'mail_smtpport' => '25',
'mail_smtptimeout' => 10,
'mail_smtpauthtype' => 'LOGIN',
'mail_sendmailmode' => 'smtp',
'mail_from_address' => 'nextcloud',
'mail_domain' => 'yourdomain.de',
```


## Updating Nextcloud

### Web Updates

The web updater can be used. Just click update and wait until it's finished.
Then continue to the provided link the to update to do the "upgrade". This step
can also be done on the command line with the following command:

```sh
cd /var/www/nextcloud/
sudo -u www-data php occ upgrade
```

### Command Line

To run in non-interactive mode:
```sh
sudo -u www-data php /var/www/nextcloud/updater/updater.phar --no-interaction
```

The whole update can be done via the command line, too, and it's a guided
process, so answer the interactive questions and the update will do its thing.
This executes the same steps as the web updater.

```sh
sudo -u www-data php /var/www/nextcloud/updater/updater.phar
```

After this step is finished, `occ upgrade` must be run either manually or just
respond with `y` to the final questions of the update process above as it will
ask you whether it should run `occ upgrade` for you.

The maintenance mode is enabled automatically and will be disabled
automatically, too. Manually, you can run the following with `--on` or `--off`.

```sh
sudo -u www-data php occ maintenance:mode --on
```

### Manual steps

Manual steps which the auto updater does not do because the *may* be time
consuming. These can be run without moving the Nextcloud instance in
maintenance mode.

```sh
sudo -u www-data php occ db:add-missing-columns
sudo -u www-data php occ db:add-missing-indices
```

## Troubleshooting

If files do not show up, do a rescan.
```sh
cd /var/www/nextcloud/
sudo -u www-data php console.php files:scan --all
```

There is also a repair function, which ... repairs things.
```sh
cd /var/www/nextcloud/
sudo -u www-data php occ maintenance:repair
```

## Backup

Enable maintenance
```sh
cd /var/www/nextcloud
sudo -u www-data php occ maintenance:mode --on
```

### Create backup

Copy everything
```sh
cd /var/www/
rsync -Aavx nextcloud/ nextcloud-dirbkp_`date +"%Y%m%d"`/
```

Create backup of MariaDB:

The user can be `root` or the created db user for nextcloud. The password will
be asked interactively. The value `nextcloud` sets the database to be exported
(it's not the password).

```sh
mysqldump --single-transaction --default-character-set=utf8mb4 -u root -p nextcloud > nextcloud-sqlbkp_`date +"%Y%m%d"`.bak
```

### Restore Backup

```sh
rsync -Aax nextcloud-dirbkp/ nextcloud/
```

After restoring a backup, run the `occ maintenance:data-fingerprint` command.
This will change the ETag for all files allowing sync client to realize that
files were changed.

Before restoring an sqldump, drop and recreate the nextcloud table.
```sh
mysql -u root -p
```

Execute
```sql
DROP DATABASE nextcloud;
CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

Then restore from backup file.
```sh
mysql -h [server] -u [username] -p[password] [db_name] < nextcloud-sqlbkp.bak
# specific with interactive password prompt:
mysql -u root -p nextcloud < nextcloud_sqlbkp.bak
```



## Misc

Some command for `occ`

Clean trashbin for all users.
```sh
sudo -u www-data php occ trashbin:cleanup  --all-users
```

Rescan files for all users.
```sh
sudo -u www-data php occ files:scan --all
```

Delete file cache entries that have not matching entreis in the storage table.
```sh
sudo -u www-data php occ files:cleanup

Update all apps.
```sh
sudo -u www-data php occ app:update --all
```

Show status information about Nextlcoud installation.
```sh
sudo -u www-data php occ status
```

## Calendar

I think this is not neccessary as the cron job is running every 5 min.
Otherwise, do I want this anyway?

Sending notifications with `occ`.
```sh
crontab -u www-data -e
```

Append
```
*/5 * * * * php -f /var/www/nextcloud/occ dav:send-event-reminders
```

Then change the sending mode from `background-job` to `occ`:
```sh
cd /var/www/nextcloud/
sudo -u www-data php occ config:app:set dav sendEventRemindersMode --value occ
```


## Misc todo

- [ ] TODO: db: is READ_COMMITTED?
- [ ] TODO: They recomend to move the `data` directory somewhere else and do
  not leave it in the document root, e.g. `/var/www/nextcloud/data`.
- [ ] TODO MAYBE: activate HTTP/2.0








