# Runbook: Restauración de sitios WordPress en entorno local usando Docker

**Stack:** cPanel - Docker - MySQL - WordPress  
**Última actualización:** 23-07-2026
**Objetivo:** Probar la integridad de los respaldos sin tocar produccion.

---

## Prerrequisitos

- `Docker` y `Docker Compose` instalados.
- Respaldo completo desde `cPanel` descargado localmente (`.tar.gz`).

---

## Paso 1: Descargar el respaldo completo desde cPanel => Asistente de copias de seguridad

Esto generará un archivo `.tar.gz` que contiene:
- `homedir/public_html.zip`: Todos los archivos de `WordPress`.
- `mysql/your_database.sql`: Volcado completo de la base de datos.

## Paso 2: Preparar el directorio de trabajo

```bash
mkdir restore-test
cd restore-test
```

Extraer el respaldo:

```bash
tar -xzf your_backup_file.tar.gz
```

Extraer los archivos de `WordPress`:

```bash
cd backup-*/homedir
unzip public_html.zip -d ../../wp-restore
cd ../../
```

Verificar estructura:

```bash
ls wp-restore/public_html/wp-config.php  # Debe existir
ls backup-*/mysql/*.sql                  # Debe existir
```

## Paso 3: Crear el archivo docker-compose.yml

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

Reemplazar `your_database_name` con el nombre real del archivo `.sql` (omitir la extension).

## Paso 4: Iniciar contenedores

```bash
docker compose up -d
docker compose ps       # Verificar que tanto la base de datos como WordPress están corriendo.
```

## Problemas comunes en esta etapa

### Problema 1: Puerto ya en uso

```
Bind for 0.0.0.0:8090 failed: port is already allocated
```
Cambiar el puerto en el archivo `docker-compose.yml`: `8090:80` => `8091:80` o cualquier otro puerto libre.

### Problema 2: Error de propiedad de archivos (Error 403)

```
AH00529: unable to check htaccess file, ensure it is readable
```
Corregir propiedad:
```bash
docker exec -it <wordpress-container-name> chown -R www-data:www-data /var/www/html
```

### Problema 3: Directivas de LiteSpeed rompiendo Apache (Error 500)

```
Invalid command 'CacheLookup'
Invalid command 'vErrorDocument'
```
Eliminar bloques de código de `LiteSpeed` en el archivo `.htaccess` dentro del contenedor:
```bash
docker exec -it <wordpress-container-name> bash
sed -i '/# BEGIN LSCACHE/,/# END LSCACHE/d' /var/www/html/.htaccess
sed -i '/# BEGIN NON_LSCACHE/,/# END NON_LSCACHE/d' /var/www/html/.htaccess
sed -i 's/vErrorDocument/ErrorDocument/' /var/www/html/.htaccess
exit
```

### Problema 4: Redireccion HTTPS causando error SSL

El bloque `Forzar HTTPS` en el archivo `.htaccess` redirige hacia `https://localhost`, que no tiene un certificado `SSL`.
 
La solución es eliminar el bloque `Forzar HTTPS` dentro del contenedor:
```bash
docker exec -it <wordpress-container-name> bash
sed -i '/# Force HTTPS (safety net)/,/^$/d' /var/www/html/.htaccess
exit
```
 
También limpiar la caché `HSTS` en el navegador:
- **Firefox:** Configuración => Privacidad y seguridad => Cookies y datos del sitio => Administrar datos => eliminar `localhost`.
- **Chrome:** acceder a `chrome://net-internals/#hsts` => Eliminar dominio: `localhost`.

### Problema 5: Error de conexión con la base de datos

Este error es disparado porque `wp-config.php` aun tiene las credenciales de produccion.
 
La solución es actualizar las credenciales dentro del contenedor:
```bash
docker exec -it <wordpress-container-name> bash
sed -i "s/define( 'DB_NAME'.*/define( 'DB_NAME', 'your_database_name' );/" /var/www/html/wp-config.php
sed -i "s/define( 'DB_USER'.*/define( 'DB_USER', 'wpuser' );/" /var/www/html/wp-config.php
sed -i "s/define( 'DB_PASSWORD'.*/define( 'DB_PASSWORD', 'wppassword' );/" /var/www/html/wp-config.php
sed -i "s/define( 'DB_HOST'.*/define( 'DB_HOST', 'db' );/" /var/www/html/wp-config.php
exit
```
 
Verificar:
```bash
docker exec -it <wordpress-container-name> grep -E "DB_NAME|DB_USER|DB_PASSWORD|DB_HOST" /var/www/html/wp-config.php
```

## Paso 5: Verificar la restauración

Navegar a `http://localhost:8090` y confirmar:
- La pagina de inicio carga correctamente.
- Productos/contenido visible.
- Inicio de sesión en el administrador funciona correctamente.
- No hay errores PHP visibles.

## Paso 6: Limpieza

```bash
docker compose down -v
cd ..
rm -rf restore-test
```

---