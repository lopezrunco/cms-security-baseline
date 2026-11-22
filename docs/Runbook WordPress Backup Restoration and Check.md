# Runbook: Restoring WordPress Sites in a Local Environment Using Docker

**Stack:** cPanel - Docker - MySQL - WordPress  
**Last updated:** 23-07-2026
**Objective:** Test backup integrity without touching production.

---

## Prerequisites

- `Docker` and `Docker Compose` installed.
- Full `cPanel` backup downloaded locally (`.tar.gz`).

---

## Step 1: Download the full backup from cPanel => Backup Wizard

This will generate a `.tar.gz` file containing:
- `homedir/public_html.zip`: All `WordPress` files.
- `mysql/your_database.sql`: Full database dump.

## Step 2: Prepare the working directory

```bash
mkdir restore-test
cd restore-test
```

Extract the backup:

```bash
tar -xzf your_backup_file.tar.gz
```

Extract the `WordPress` files:

```bash
cd backup-*/homedir
unzip public_html.zip -d ../../wp-restore
cd ../../
```

Verify the structure:

```bash
ls wp-restore/public_html/wp-config.php  # Must exist
ls backup-*/mysql/*.sql                  # Must exist
```

## Step 3: Create the docker-compose.yml file

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: your_database_name
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wppassword
    volumes:
      - db_data:/var/lib/mysql
      - ./backup-*/mysql/your_database.sql:/docker-entrypoint-initdb.d/restore.sql
 
  wordpress:
    image: wordpress:latest
    depends_on:
      - db
    ports:
      - "8090:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: your_database_name
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppassword
    volumes:
      - ./wp-restore/public_html:/var/www/html
 
volumes:
  db_data:
```

Replace `your_database_name` with the actual name of the `.sql` file (omit the extension).

## Step 4: Start the containers

```bash
docker compose up -d
docker compose ps       # Verify that both the database and WordPress are running.
```

## Common problems at this stage

### Problem 1: Port already in use

```
Bind for 0.0.0.0:8090 failed: port is already allocated
```
Change the port in the `docker-compose.yml` file: `8090:80` => `8091:80` or any other free port.

### Problem 2: File ownership error (Error 403)

```
AH00529: unable to check htaccess file, ensure it is readable
```
Fix ownership:
```bash
docker exec -it <wordpress-container-name> chown -R www-data:www-data /var/www/html
```

### Problem 3: LiteSpeed directives breaking Apache (Error 500)

```
Invalid command 'CacheLookup'
Invalid command 'vErrorDocument'
```
Remove the `LiteSpeed` code blocks from the `.htaccess` file inside the container:
```bash
docker exec -it <wordpress-container-name> bash
sed -i '/# BEGIN LSCACHE/,/# END LSCACHE/d' /var/www/html/.htaccess
sed -i '/# BEGIN NON_LSCACHE/,/# END NON_LSCACHE/d' /var/www/html/.htaccess
sed -i 's/vErrorDocument/ErrorDocument/' /var/www/html/.htaccess
exit
```

### Problem 4: HTTPS redirect causing an SSL error

The `Force HTTPS` block in the `.htaccess` file redirects to `https://localhost`, which does not have an `SSL` certificate.
 
The solution is to remove the `Force HTTPS` block inside the container:
```bash
docker exec -it <wordpress-container-name> bash
sed -i '/# Force HTTPS (safety net)/,/^$/d' /var/www/html/.htaccess
exit
```
 
Also clear the `HSTS` cache in the browser:
- **Firefox:** Settings => Privacy & Security => Cookies and Site Data => Manage Data => delete `localhost`.
- **Chrome:** go to `chrome://net-internals/#hsts` => Delete domain: `localhost`.

### Problem 5: Database connection error

This error is triggered because `wp-config.php` still has the production credentials.
 
The solution is to update the credentials inside the container:
```bash
docker exec -it <wordpress-container-name> bash
sed -i "s/define( 'DB_NAME'.*/define( 'DB_NAME', 'your_database_name' );/" /var/www/html/wp-config.php
sed -i "s/define( 'DB_USER'.*/define( 'DB_USER', 'wpuser' );/" /var/www/html/wp-config.php
sed -i "s/define( 'DB_PASSWORD'.*/define( 'DB_PASSWORD', 'wppassword' );/" /var/www/html/wp-config.php
sed -i "s/define( 'DB_HOST'.*/define( 'DB_HOST', 'db' );/" /var/www/html/wp-config.php
exit
```
 
Verify:
```bash
docker exec -it <wordpress-container-name> grep -E "DB_NAME|DB_USER|DB_PASSWORD|DB_HOST" /var/www/html/wp-config.php
```

## Step 5: Verify the restoration

Navigate to `http://localhost:8090` and confirm:
- The home page loads correctly.
- Products/content are visible.
- Login to the admin works correctly.
- No PHP errors are visible.

## Step 6: Cleanup

```bash
docker compose down -v
cd ..
rm -rf restore-test
```

---