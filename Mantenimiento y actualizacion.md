# Mantenimiento y actualización

**Aplica a:** Todos los sitios que usan `WordPress` o `Joomla`.  
**Última actualización:** 23-07-2026

---

## Política de respaldos

| Frecuencia | Responsable | Tipo |
|---|---|---|
| Semanal (automático) | Proveedor de hosting | Respaldo completo desde `cPanel` |
| Mensual | Desarrollador | Respaldo completo desde `cPanel` |
| Antes de hacer cambios en el sitio | Desarrollador | Respaldo completo desde `cPanel` |
| Antes de actualizar plugins/plantilla/CMS | Desarrollador | Respaldo completo desde `cPanel` |
| Después de confirmar que las actualizaciones son estables | Desarrollador | Respaldo completo desde `cPanel` |

Las actualizaciones automáticas deben estar **desactivadas en todos los sitios**. Eso aplica al CMS, los plugins y la plantilla.

Todos los plugins, plantillas y núcleo del CMS (`WordPress`/`Joomla`) serán revisados y actualizados **mensualmente** por el desarrollador responsable del sitio.
 
**Almacenamiento de los respaldos:** Descargar localmente, verificar su integridad (por ejemplo, usando [Docker](./docs/Runbook:%20WordPress%20Backup%20Restoration.md)) y almacenar de forma local y en una ubicación externa (nube o disco externo). No confiar solamente en la copia del proveedor de hosting.

**Retención de respaldos recomendada para los desarrolladores**

- **Últimos 3 respaldos manuales:** Eso significa un antes/después de los cambios recientes sin acumular mucho espacio.

- **Último respaldo limpio después de un incidente:** Si algún malware reaparece, es imperativo tener una base limpia para la restauración. Este respaldo nunca se borra a no ser que el sitio haya estado libre de incidentes durante un período de 6 meses.

---

## Checklist de actualización mensual

- [ ] Respaldo manual antes de comenzar.
- [ ] Abrir el administrador y verificar las actualizaciones disponibles.
- [ ] Verificar las versiones de los componentes instalados comparándolas con las bases de datos de vulnerabilidades de `WPScan` y VEL (Vulnerable Extensions List) para identificar vulnerabilidades conocidas (`CVE`). 
- [ ] Aplicar las actualizaciones una a la vez, verificando el sitio cada vez.
- [ ] Aplicar las actualizaciones en el siguiente orden: 
    1. Plugins 
    2. Plantilla 
    3. CMS.
- [ ] Limpiar el caché después de actualizar.
- [ ] Verificar que el sitio carga correctamente en móviles y escritorio.
- [ ] Crear un respaldo manual después de confirmar que las actualizaciones son estables.
- [ ] Realizar escaneo de seguridad (`WPScan`, `Imunify Security` o equivalente en `cPanel`).
- [ ] Revisar las alertas de seguridad de los plugins.

---

## Registro de respaldos

Cada desarrollador es responsable de mantener un registro de los respaldos de sus sitios.

Se provee una plantilla de registro en [`templates/backup-log.md`](./templates/backup-log.md).

---