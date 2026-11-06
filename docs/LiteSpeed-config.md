# Checklist de configuración del plugin LiteSpeed Cache en sitios WordPress

**Última actualización:** 04-11-2026

---

## 1: Caché

| Ajuste | Valor | Comentarios |
|---|---|---|
| Activa cache | ON | Función principal. |
| Cachear usuarios con sesión iniciada | OFF | Evita que se filtre contenido de un usuario con sesión a otro. |
| Cachear comentaristas | OFF | Mismo motivo. |
| Cachear API REST | OFF | Las respuestas REST pueden contener datos privados. |
| Cachear página de acceso | OFF | Evita nonces o tokens obsoletos en la página de acceso. |
| Cache móvil | OFF | Activar solo si el tema sirve HTML distinto a móviles. |
| Lista de User Agents móviles | Por defecto | Solo importa si Cache móvil está en ON. |
| URIs cacheadas privadamente | Vacío | Gestiona las rutas sensibles en la pantalla 4. |
| Forzar URLs en caché | Vacío | Anula las exclusiones. |
| Forzar URIs de caché pública | Vacío | Igual que el anterior, y el más riesgoso. |
| Ignorar cadenas de consulta | Por defecto (`fbclid`, `gclid`, `utm*`, `_ga`) | Solo parámetros de seguimiento. Nunca agregar parámetros que cambien el contenido. |

## 2: TTL

| Ajuste | Valor | Comentarios |
|---|---|---|
| TTL público (604800) | Mantener, o bajar a 86400 si el contenido cambia a menudo | No es una vulnerabilidad, pero un TTL más corto limita cuánto tiempo viven las páginas obsoletas. |
| TTL privado (1800) | Mantener | Ya es corto. |
| TTL página principal (604800) | Mantener | |
| TTL Feed (604800) | Mantener | Los feeds son públicos. |
| TTL REST (604800) | 0 | Defensa en profundidad: Desactiva el caché REST aunque alguien active Cachear API REST más adelante. |
| TTL códigos de estado (`404 3600`, `500 600`) | Mantener | |

## 3: Purgar

| Ajuste | Valor | Comentarios |
|---|---|---|
| Purgar todo al actualizar | ON | Tras una actualización de seguridad, las páginas y recursos en caché provienen del código ya parcheado. |
| Reglas de purga automática | Marcar todo | Lo más simple y seguro para un sitio pequeño. |
| Servir contenido rancio | OFF | Por diseño sirve copias antiguas. |
| URLs de purga programada | Vacío | Opcional. |
| Hora de purga programada | Vacío | |
| Ganchos de purgar todo | Por defecto | |

## 4: Excluir

| Ajuste | Valor | Comentarios |
|---|---|---|
| URIs a no cachear | Agregar -una por línea- rutas de reservas, formularios de contacto y como `/contacto`, `/turnos`, `/reservar`, `/mi-cuenta`. | Mantiene fuera del caché las páginas con formularios y tokens. |
| Cadenas de consulta a no cachear | Agregar lo que los formularios o plugins usen para llevar estado, como `token`, `session`, `key`. | Opcional, pero seguro. |
| Categorías / Etiquetas a no cachear | Vacío salvo que haga falta | |
| Cookies a no cachear | Agregar las cookies que establezca cualquier plugin de reservas o formularios, si las hay. | Evita cachear respuestas personalizadas. |
| User Agents a no cachear | Vacío | |
| No cachear perfiles | Marcar Administrator, Editor, Author, Contributor | Roles de mantenimiento nunca deben recibir páginas en caché. Marcar también Subscriber si hay usuarios reales con cuenta. |

## 5: ESI

| Ajuste | Valor | Comentarios |
|---|---|---|
| Activar ESI | OFF | Añade complejidad y superficie de ataque. No es necesario si no hay tráfico público con sesión iniciada. |
| Cachear barra de administrador | OFF | |
| Cachear formulario de comentario | OFF | |
| Nonces de ESI | Dejar como está | Solo relevante si ESI está en ON. |
| Grupos de variación | Dejar (Administrator 99, el resto 0) | Solo relevante si ESI está en ON. |

Si alguna vez activas ESI, vuelve a probar todos los formularios y todas las vistas con sesión iniciada.

## 6: Caché de objetos

| Ajuste | Valor | Comentarios |
|---|---|---|
| Caché de objetos | OFF | Las extensiones Redis y Memcached aparecen como *Desactivadas*, así que no hay nada a lo que conectarse. |
| Método / Host / Puerto / Usuario / Contraseña / ID de base de datos | Dejar valores por defecto | Irrelevante mientras esté en OFF. |
| Conexión persistente | OFF | |
| Caché de WP-Admin | OFF | Los datos obsoletos en el administrador son un riesgo. |

Si la activas más adelante, usa Redis o Memcached en localhost o en un socket UNIX. Exige contraseña, nunca expongas el puerto y usa un prefijo de clave único por sitio.

## 7: Caché del navegador

| Ajuste | Valor | Comentarios |
|---|---|---|
| Caché del navegador | ON | Solo archivos estáticos. Observacion: Edita `.htaccess`. |
| TTL caché de navegador (31557600 = aproximadamente 1 año) | Mantener si los recursos tienen versión. Si no, usar 604800. | Un año está bien para archivos versionados y es riesgoso para los que no lo están. |

## 8: Avanzado

| Ajuste | Valor | Comentarios |
|---|---|---|
| TTL de caché AJAX | Vacío | Cachear acciones AJAX puede exponer datos dinámicos. |
| Cookie de acceso | Por defecto `_lscache_vary` | Cambiar solo si varias instalaciones de WordPress comparten dominio. |
| Variar cookies | Vacío | |
| Mejorar compatibilidad HTTP/HTTPS | OFF | Fuerza HTTPS en todo el sitio con HSTS en su lugar. |
| Clic instantáneo | OFF | La precarga genera peticiones GET extra y aumenta la carga del servidor. |