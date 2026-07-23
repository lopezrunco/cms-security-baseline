# Mantenimiento y actualizacion

**Aplica a:** Todos los sitios que usan WordPress o Joomla.  
**Ultima actualizacion:** 23-07-2026

---

## Politica de respaldos

| Frecuencia | Responsable | Tipo |
|---|---|---|
| Semanal (automatico) | Provedor de Hosting | Respaldo completo desde cPanel |
| Mensual | Desarrollador | Respaldo completo desde cPanel |
| Antes de hacer cambios en el sitio | Desarrollador | Respaldo completo desde cPanel |
| Antes de actualizar plugins/plantilla/CMS | Desarrollador | Respaldo completo desde cPanel |
| Despues de confirmar que las actualizaciones son estables | Desarrollador | Respaldo completo desde cPanel |

Las actualizaciones automaticas deben de estar **desactivadas en todos los sitios**. Eso aplica tanto a para el CMS, los plugins y la plantilla.

Todos los plugins, plantillas y nucelo del CMS (WordPress/Joomla) seran revisados y actualizados **mensualmente** por el desarrollador reponsable del sitio.
 
**Almacenamiento de los respaldos:** Descargar localmente, chequear su integridad (por ejemplo usando [Docker](./docs/WordPress%20Backup%20Restoration.md)) y almacenar de forma local y en una ubicación externa (nube o disco externo). No confiar solamente en la copia del provedor de hosting.

**Retencion de respaldos recomendada para los desarrolladores**

- **Ultimos 3 respaldos manuales:** Eso significa un antes/despues de los cambios recientes sin acumular mucho espacio.

- **Ultimo respaldo limpio despues de un incidente:** Si algun malware reaparece, es imperativo tener una base limpia para la restauracion. Este respaldo nunca se borra a no ser que el sitio haya estado libre de incidentes por los ultimos 6 meses.

---

## Checklist de actualizacion mensual

- [ ] Respaldo manual antes de comenzar.
- [ ] Abrir el administrador y chequear las actualizaciones disponibles.
- [ ] Verificar las versiones de los componentes instalados comparándolas con las bases de datos de WPScan y VEL (Vulnerable Extensions List) para identificar vulnerabilidades conocidas (CVE). 
- [ ] Aplicar las actualizaciones una a la vez, verificando el sitio cada vez.
- [ ] Las actualizaciones seran en este orden: 1. Plugins. 2. Plantilla. 3. CMS.
- [ ] Limpiar el cache despues de actualizar.
- [ ] Verificar que el sitio carga correctamente en moviles y escritorio.
- [ ] Respaldo manual despues de confirmar que las actualizaciones son estables.
- [ ] Realizar escaneo de seguridad (WPScan, Imunify Security o equivalente en cPanel)
- [ ] Chequear cualquier alerta de seguridad de los plugins

---

## Plantilla de registro de respaldos

### Respaldos manuales (mantener ultimos 3)

| # | Fecha | Evento | Nombre del archivo | Localizacion del respaldo | Borrar despues de |
|---|---|---|---|---|---|
| *Ej* | *2026-07-23* | *Antes de incidente se seguridad* | *backup-7.23.2026_site.tar.gz* | *Google Drive / Clientes* | *Cuando se agregue el respaldo #4* |
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |

> Cuando agregue una fila, borre la mas antigua.

### Ultimo respaldo limpio (mantenerlo indefinidamente o minimo 6 meses sin incidentes)

| Fecha | Contexto | Nombre del archivo | Localizacion del respaldo | Es seguro borrar despues de |
|---|---|---|---|---|
| *Ej* | *Post incidente DDoS julio 2026. Sitio limpio verificado por Imunify* | *backup-7.23.2026_site_clean.tar.gz* | *Google Drive / Clientes* | *Enero 2027* |
| | | | | |

---